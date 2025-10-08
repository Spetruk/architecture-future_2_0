#!/bin/bash

# Скрипт для настройки S3 backend для Terraform
# Использует Yandex Object Storage

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка наличия необходимых переменных
check_variables() {
    log "Проверка переменных окружения..."
    
    required_vars=("YC_ACCESS_KEY_ID" "YC_SECRET_ACCESS_KEY" "YC_CLOUD_ID" "YC_FOLDER_ID")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            error "Переменная $var не установлена"
            exit 1
        fi
    done
    
    log "Все необходимые переменные установлены"
}

# Создание S3 bucket для состояния Terraform
create_bucket() {
    log "Создание S3 bucket для состояния Terraform..."
    
    bucket_name="terraform-state-bucket"
    
    # Проверяем, существует ли bucket
    if aws s3 ls "s3://$bucket_name" 2>/dev/null; then
        warn "Bucket $bucket_name уже существует"
    else
        log "Создание bucket $bucket_name..."
        aws s3 mb "s3://$bucket_name" \
            --endpoint-url="https://storage.yandexcloud.net" \
            --region="ru-central1"
        
        # Включаем версионирование
        aws s3api put-bucket-versioning \
            --bucket "$bucket_name" \
            --versioning-configuration Status=Enabled \
            --endpoint-url="https://storage.yandexcloud.net"
        
        # Включаем шифрование
        aws s3api put-bucket-encryption \
            --bucket "$bucket_name" \
            --server-side-encryption-configuration '{
                "Rules": [
                    {
                        "ApplyServerSideEncryptionByDefault": {
                            "SSEAlgorithm": "AES256"
                        }
                    }
                ]
            }' \
            --endpoint-url="https://storage.yandexcloud.net"
        
        log "Bucket $bucket_name создан с версионированием и шифрованием"
    fi
}

# Настройка блокировки состояния (DynamoDB)
setup_locking() {
    log "Настройка блокировки состояния..."
    
    table_name="terraform-state-lock"
    
    # Проверяем, существует ли таблица
    if aws dynamodb describe-table --table-name "$table_name" --endpoint-url="https://docapi.serverless.yandexcloud.net" 2>/dev/null; then
        warn "Таблица $table_name уже существует"
    else
        log "Создание таблицы DynamoDB для блокировки состояния..."
        aws dynamodb create-table \
            --table-name "$table_name" \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
            --endpoint-url="https://docapi.serverless.yandexcloud.net" \
            --region="ru-central1"
        
        log "Таблица $table_name создана"
    fi
}

# Инициализация Terraform для всех окружений
init_terraform() {
    log "Инициализация Terraform для всех окружений..."
    
    environments=("dev" "stage" "prod")
    
    for env in "${environments[@]}"; do
        log "Инициализация окружения $env..."
        
        cd "envs/$env"
        
        terraform init \
            -backend-config="access_key=$YC_ACCESS_KEY_ID" \
            -backend-config="secret_key=$YC_SECRET_ACCESS_KEY" \
            -backend-config="dynamodb_table=terraform-state-lock" \
            -backend-config="dynamodb_endpoint=https://docapi.serverless.yandexcloud.net"
        
        cd - > /dev/null
        
        log "Окружение $env инициализировано"
    done
}

# Основная функция
main() {
    log "Настройка Terraform backend с S3..."
    
    check_variables
    create_bucket
    setup_locking
    init_terraform
    
    log "Настройка завершена успешно!"
    log "Теперь можно использовать terraform plan/apply для развертывания"
}

# Запуск скрипта
main "$@"

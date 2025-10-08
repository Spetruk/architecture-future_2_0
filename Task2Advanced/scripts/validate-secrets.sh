#!/bin/bash

# Скрипт для валидации секретов GitHub Actions
# Проверяет наличие всех необходимых секретов

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

# Список необходимых секретов
required_secrets=(
    "YANDEX_TOKEN"
    "YC_ACCESS_KEY_ID"
    "YC_SECRET_ACCESS_KEY"
    "YC_CLOUD_ID"
    "YC_FOLDER_ID"
    "YC_SUBNET_ID"
    "SSH_PUBLIC_KEY"
)

# Функция для проверки секретов
check_secrets() {
    log "Проверка секретов GitHub Actions..."
    
    missing_secrets=()
    
    for secret in "${required_secrets[@]}"; do
        if [ -z "${!secret}" ]; then
            missing_secrets+=("$secret")
        fi
    done
    
    if [ ${#missing_secrets[@]} -eq 0 ]; then
        log "Все необходимые секреты установлены"
        return 0
    else
        error "Отсутствуют следующие секреты:"
        for secret in "${missing_secrets[@]}"; do
            echo "  - $secret"
        done
        return 1
    fi
}

# Функция для отображения инструкций по настройке
show_setup_instructions() {
    log "Инструкции по настройке секретов:"
    echo ""
    echo "1. Перейдите в настройки репозитория GitHub"
    echo "2. Выберите 'Secrets and variables' -> 'Actions'"
    echo "3. Добавьте следующие секреты:"
    echo ""
    
    for secret in "${required_secrets[@]}"; do
        case $secret in
            "YANDEX_TOKEN")
                echo "   $secret: OAuth токен Yandex Cloud"
                ;;
            "YC_ACCESS_KEY_ID")
                echo "   $secret: Access Key ID для Yandex Object Storage"
                ;;
            "YC_SECRET_ACCESS_KEY")
                echo "   $secret: Secret Access Key для Yandex Object Storage"
                ;;
            "YC_CLOUD_ID")
                echo "   $secret: ID облака Yandex Cloud"
                ;;
            "YC_FOLDER_ID")
                echo "   $secret: ID папки Yandex Cloud"
                ;;
            "YC_SUBNET_ID")
                echo "   $secret: ID подсети для ВМ"
                ;;
            "SSH_PUBLIC_KEY")
                echo "   $secret: Публичный SSH ключ"
                ;;
        esac
    done
    
    echo ""
    echo "4. Настройте окружения (dev, stage, prod) в GitHub Actions"
    echo "5. Для prod окружения рекомендуется включить защиту веток"
}

# Основная функция
main() {
    log "Валидация секретов GitHub Actions..."
    
    if check_secrets; then
        log "Проверка завершена успешно!"
    else
        show_setup_instructions
        exit 1
    fi
}

# Запуск скрипта
main "$@"

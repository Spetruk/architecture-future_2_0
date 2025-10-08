# Terraform CI/CD с удаленным состоянием

Автоматизированное развертывание инфраструктуры через GitHub Actions с использованием удаленного хранения состояния в S3-совместимом хранилище.

## 🏗️ Архитектура

```
Task2Advanced/
├── modules/ -> ../Task1Advanced/modules/  # Символическая ссылка на модуль
├── envs/ -> ../Task1Advanced/envs/        # Символическая ссылка на окружения
├── .github/workflows/                     # GitHub Actions
│   ├── terraform.yml                      # Основной pipeline
│   ├── terraform-manual.yml               # Ручное развертывание
│   └── security-scan.yml                  # Сканирование безопасности
├── scripts/                               # Вспомогательные скрипты
│   ├── setup-backend.sh                   # Настройка backend
│   └── validate-secrets.sh                # Валидация секретов
└── README.md
```

## 🔧 Компоненты

### 1. Terraform Backend
- **Хранилище**: Yandex Object Storage (S3-совместимое)
- **Блокировка**: DynamoDB для предотвращения конфликтов
- **Версионирование**: Автоматическое версионирование состояния
- **Шифрование**: AES256 для защиты данных

### 2. GitHub Actions Pipeline
- **Валидация**: Проверка синтаксиса и форматирования
- **Планирование**: Создание плана изменений
- **Применение**: Развертывание с подтверждением
- **Безопасность**: Сканирование на уязвимости

### 3. Изоляция окружений
- **Отдельные состояния**: Каждое окружение имеет свой state файл
- **Защита веток**: Prod требует ручного подтверждения
- **Переменные окружения**: Изолированные секреты

## 🚀 Быстрый старт

### 1. Настройка секретов GitHub

Добавьте следующие секреты в настройках репозитория:

| Секрет | Описание |
|--------|----------|
| `YANDEX_TOKEN` | OAuth токен Yandex Cloud |
| `YC_ACCESS_KEY_ID` | Access Key для Object Storage |
| `YC_SECRET_ACCESS_KEY` | Secret Key для Object Storage |
| `YC_CLOUD_ID` | ID облака Yandex Cloud |
| `YC_FOLDER_ID` | ID папки Yandex Cloud |
| `YC_SUBNET_ID` | ID подсети для ВМ |
| `SSH_PUBLIC_KEY` | Публичный SSH ключ |

### 2. Настройка окружений

Создайте окружения в GitHub Actions:
- `dev` - для разработки
- `stage` - для тестирования  
- `prod` - для продакшена (с защитой)

### 3. Настройка backend

```bash
# Установите AWS CLI для работы с Yandex Object Storage
pip install awscli

# Настройте переменные окружения
export YC_ACCESS_KEY_ID="your-access-key"
export YC_SECRET_ACCESS_KEY="your-secret-key"
export YC_CLOUD_ID="your-cloud-id"
export YC_FOLDER_ID="your-folder-id"

# Запустите скрипт настройки
./scripts/setup-backend.sh
```

### 4. Запуск pipeline

#### Автоматический запуск
- **Push в main**: Автоматическое развертывание в prod
- **Pull Request**: Планирование изменений
- **Push в develop**: Развертывание в dev

#### Ручной запуск
1. Перейдите в Actions
2. Выберите "Terraform Manual Deployment"
3. Укажите окружение и действие
4. Нажмите "Run workflow"

### 5. Различия между Task1Advanced и Task2Advanced

| Компонент | Task1Advanced | Task2Advanced |
|-----------|---------------|---------------|
| **Модуль VM** | Локальный | Символическая ссылка |
| **Окружения** | Локальные | Символические ссылки |
| **Backend** | Локальный (закомментирован) | S3-совместимый (активируется в CI/CD) |
| **CI/CD** | Отсутствует | GitHub Actions |
| **Безопасность** | Базовая | Расширенная |
| **Использование** | Ручное | Автоматизированное |

### 6. Как работает backend

В Task1Advanced backend закомментирован:
```hcl
# backend "s3" {
#   endpoint = "storage.yandexcloud.net"
#   bucket   = "terraform-state-bucket"
#   key      = "dev/terraform.tfstate"
#   ...
# }
```

В Task2Advanced GitHub Actions активирует backend через параметры:
```bash
terraform init \
  -backend-config="access_key=${{ secrets.YC_ACCESS_KEY_ID }}" \
  -backend-config="secret_key=${{ secrets.YC_SECRET_ACCESS_KEY }}"
```

## 📋 Workflow детали

### Основной pipeline (`terraform.yml`)

```yaml
jobs:
  validate:     # Проверка кода
  plan:         # Планирование изменений
  apply:        # Применение изменений
  notify:       # Уведомления
```

**Триггеры:**
- Push в main/develop
- Pull Request
- Manual dispatch

### Ручное развертывание (`terraform-manual.yml`)

**Возможности:**
- Выбор окружения (dev/stage/prod)
- Выбор действия (plan/apply/destroy)
- Автоматическое подтверждение

### Сканирование безопасности (`security-scan.yml`)

**Инструменты:**
- TFSec - сканирование Terraform
- Checkov - анализ безопасности
- Trivy - поиск уязвимостей

## 🔒 Безопасность

### 1. Управление секретами
- Все чувствительные данные в GitHub Secrets
- Переменные помечены как `sensitive = true`
- Секреты не логируются в выводе

### 2. Изоляция окружений
- Отдельные state файлы для каждого окружения
- Изолированные переменные окружения
- Защита prod окружения

### 3. Контроль доступа
- Защита веток для prod
- Требование ревью для изменений
- Аудит через GitHub Actions

## 🛠️ Команды

### Локальная разработка

```bash
# Инициализация
cd envs/dev
terraform init -backend-config="access_key=..." -backend-config="secret_key=..."

# Планирование
terraform plan -var-file="terraform.tfvars"

# Применение
terraform apply -var-file="terraform.tfvars"

# Уничтожение
terraform destroy -var-file="terraform.tfvars"
```

### Управление состоянием

```bash
# Просмотр состояния
terraform show

# Список ресурсов
terraform state list

# Импорт ресурса
terraform import yandex_compute_instance.vm instance-id
```

## 🔍 Мониторинг

### Логи GitHub Actions
- Детальные логи каждого шага
- Артефакты планов Terraform
- Уведомления об успехе/ошибках

### Terraform Outputs
- IP адреса ВМ
- SSH команды подключения
- ID ресурсов

## 🚨 Troubleshooting

### Частые проблемы

1. **Ошибка backend**: Проверьте доступ к Object Storage
2. **Ошибка секретов**: Убедитесь, что все секреты установлены
3. **Конфликт состояния**: Проверьте блокировку в DynamoDB
4. **Ошибка провайдера**: Обновите версию Terraform

### Полезные команды

```bash
# Проверка секретов
./scripts/validate-secrets.sh

# Настройка backend
./scripts/setup-backend.sh

# Форматирование кода
terraform fmt -recursive

# Валидация конфигурации
terraform validate
```

## 📊 Метрики

### Производительность
- Время развертывания: ~5-10 минут
- Время планирования: ~2-3 минуты
- Время валидации: ~1-2 минуты

### Надежность
- Автоматические проверки безопасности
- Изоляция окружений
- Откат изменений через версионирование

## 🔄 Обновления

### Версионирование
- Terraform: 1.5.7
- Провайдер Yandex: ~> 0.100
- GitHub Actions: v4

### Планы развития
- [ ] Интеграция с мониторингом
- [ ] Автоматическое тестирование
- [ ] Blue-Green развертывание
- [ ] Уведомления в Slack/Teams

## 📝 Лицензия

MIT License

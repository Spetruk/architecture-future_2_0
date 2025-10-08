# Terraform VM Module

Универсальный модуль для создания ВМ в Yandex Cloud с поддержкой dev/stage/prod окружений.

## Структура

```
Task1Advanced/
├── modules/vm/           # Универсальный модуль
│   ├── main.tf          # Ресурсы ВМ + диск + сеть
│   ├── variables.tf     # Входные параметры
│   └── outputs.tf       # Выходные значения
├── envs/                # Три окружения
│   ├── dev/             # 2 ядра, 4 ГБ, 20 ГБ диск
│   ├── stage/           # 4 ядра, 8 ГБ, 50 ГБ диск
│   └── prod/            # 8 ядер, 16 ГБ, 100 ГБ диск
└── README.md
```

## Параметры модуля

### Обязательные
| Параметр | Тип | Описание |
|----------|-----|----------|
| `vm_name` | string | Имя ВМ |
| `subnet_id` | string | ID подсети |
| `ssh_public_key` | string | Публичный SSH-ключ |

### Опциональные
| Параметр | Тип | По умолчанию | Описание |
|----------|-----|--------------|----------|
| `vm_cores` | number | 2 | Количество ядер |
| `vm_memory` | number | 4 | RAM в ГБ |
| `vm_disk_size` | number | 20 | Размер диска в ГБ |
| `vm_disk_type` | string | "network-ssd" | Тип диска |
| `image_family` | string | "ubuntu-2204-lts" | Образ ОС |
| `zone` | string | "ru-central1-a" | Зона доступности |
| `platform_id` | string | "standard-v1" | Платформа |
| `environment` | string | - | Окружение (dev/stage/prod) |

## Выходные значения

| Параметр | Описание |
|----------|----------|
| `vm_id` | ID ВМ |
| `vm_external_ip` | Внешний IP |
| `vm_internal_ip` | Внутренний IP |
| `ssh_connection` | Команда SSH подключения |
| `disk_id` | ID диска |

## Быстрый старт

### 1. Настройка
Отредактируйте `terraform.tfvars` в нужном окружении:
```hcl
yandex_token = "ваш-oauth-токен"
cloud_id     = "ваш-cloud-id"
folder_id    = "ваш-folder-id"
subnet_id    = "ваш-subnet-id"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... user@example.com"
```

### 2. Запуск
```bash
# Dev окружение
cd envs/dev
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# Stage окружение
cd envs/stage
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# Prod окружение
cd envs/prod
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### 3. Уничтожение
```bash
terraform destroy -var-file="terraform.tfvars"
```

### 4. Получение информации
```bash
terraform output
```

## Особенности окружений

- **Dev**: Прерываемые ВМ для экономии
- **Stage**: Стабильные ВМ для тестирования  
- **Prod**: Высокопроизводительные ВМ

## Пример использования

```hcl
module "vm" {
  source = "../../modules/vm"
  
  vm_name        = "my-vm"
  vm_cores       = 4
  vm_memory      = 8
  vm_disk_size   = 50
  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... user@example.com"
  environment    = "stage"
}
```

## Полезные команды

```bash
terraform validate    # Проверка конфигурации
terraform fmt         # Форматирование кода
terraform plan        # Просмотр плана
terraform show        # Просмотр состояния
```
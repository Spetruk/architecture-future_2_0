# Конфигурация для stage окружения

terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

# Провайдер Yandex Cloud
provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# Модуль виртуальной машины
module "vm" {
  source = "../../modules/vm"

  # Основные параметры
  vm_name        = var.vm_name
  vm_cores       = var.vm_cores
  vm_memory      = var.vm_memory
  vm_disk_size   = var.vm_disk_size
  vm_disk_type   = var.vm_disk_type
  subnet_id      = var.subnet_id
  ssh_public_key = var.ssh_public_key

  # Дополнительные параметры
  image_family = var.image_family
  zone         = var.zone
  platform_id  = var.platform_id
  nat          = var.nat
  environment  = "stage"
  project_id   = var.cloud_id
  folder_id    = var.folder_id

  # Метки
  labels = {
    Environment = "stage"
    Project     = "vm-module"
    Owner       = "devops-team"
  }
}

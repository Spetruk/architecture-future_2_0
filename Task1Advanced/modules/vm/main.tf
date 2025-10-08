# Конфигурация провайдера для модуля
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

# Получение образа ОС
data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

# Создание диска для ВМ
resource "yandex_compute_disk" "vm_disk" {
  name     = "${var.vm_name}-disk"
  type     = var.vm_disk_type
  zone     = var.zone
  image_id = data.yandex_compute_image.ubuntu.image_id
  size     = var.vm_disk_size

  labels = merge(var.labels, {
    Name        = "${var.vm_name}-disk"
    Environment = var.environment
  })
}

# Создание виртуальной машины
resource "yandex_compute_instance" "vm" {
  name        = var.vm_name
  platform_id = var.platform_id
  zone        = var.zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.vm_disk.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  labels = merge(var.labels, {
    Name        = var.vm_name
    Environment = var.environment
  })

  scheduling_policy {
    preemptible = var.environment == "dev" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }
}

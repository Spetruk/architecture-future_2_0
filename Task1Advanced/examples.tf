# Примеры использования модуля vm

# Пример 1: Базовая конфигурация
module "basic_vm" {
  source = "./modules/vm"

  vm_name        = "basic-vm"
  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@example.com"
  
  environment  = "example"
  project_id   = "b1g63e2fltlcti5hjucf"
  folder_id    = "b1g6v5q9rdsufm6s48g0"
}

# Пример 2: Высокопроизводительная ВМ
module "high_performance_vm" {
  source = "./modules/vm"

  vm_name        = "high-perf-vm"
  vm_cores       = 16
  vm_memory      = 32
  vm_disk_size   = 200
  vm_disk_type   = "network-ssd"
  platform_id    = "standard-v3"
  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@example.com"
  
  environment  = "production"
  project_id   = "b1g63e2fltlcti5hjucf"
  folder_id    = "b1g6v5q9rdsufm6s48g0"
  
  labels = {
    Environment = "production"
    Project     = "high-load"
    Owner       = "devops-team"
    Criticality = "high"
  }
}

# Пример 3: Экономичная ВМ для разработки
module "dev_vm" {
  source = "./modules/vm"

  vm_name        = "dev-vm"
  vm_cores       = 1
  vm_memory      = 2
  vm_disk_size   = 10
  vm_disk_type   = "network-hdd"
  platform_id    = "standard-v1"
  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@example.com"
  
  environment  = "development"
  project_id   = "b1g63e2fltlcti5hjucf"
  folder_id    = "b1g6v5q9rdsufm6s48g0"
  
  labels = {
    Environment = "development"
    Project     = "testing"
    Owner       = "developer"
    AutoShutdown = "true"
  }
}

# Пример 4: ВМ с локальным SSD
module "local_ssd_vm" {
  source = "./modules/vm"

  vm_name        = "local-ssd-vm"
  vm_cores       = 4
  vm_memory      = 8
  vm_disk_size   = 50
  vm_disk_type   = "local-ssd"
  platform_id    = "standard-v2"
  subnet_id      = "e9b1h0icgtq23md5ovl1"
  ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... user@example.com"
  
  environment  = "staging"
  project_id   = "b1g63e2fltlcti5hjucf"
  folder_id    = "b1g6v5q9rdsufm6s48g0"
  
  labels = {
    Environment = "staging"
    Project     = "database"
    Owner       = "dba-team"
    StorageType = "local-ssd"
  }
}

# Выходные значения для примеров
output "basic_vm_ip" {
  description = "IP адрес базовой ВМ"
  value       = module.basic_vm.vm_external_ip
}

output "high_perf_vm_ip" {
  description = "IP адрес высокопроизводительной ВМ"
  value       = module.high_performance_vm.vm_external_ip
}

output "dev_vm_ssh" {
  description = "SSH команда для dev ВМ"
  value       = module.dev_vm.ssh_connection
}

output "local_ssd_vm_info" {
  description = "Информация о ВМ с локальным SSD"
  value = {
    id          = module.local_ssd_vm.vm_id
    external_ip = module.local_ssd_vm.vm_external_ip
    internal_ip = module.local_ssd_vm.vm_internal_ip
    disk_type   = module.local_ssd_vm.disk_type
    ssh_command = module.local_ssd_vm.ssh_connection
  }
}

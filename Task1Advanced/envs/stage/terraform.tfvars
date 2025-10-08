# Конфигурация для stage окружения
# Обязательные параметры (заполните своими значениями)
yandex_token = "your-oauth-token-here"
cloud_id     = "your-cloud-id-here"
folder_id    = "your-folder-id-here"
subnet_id    = "your-subnet-id-here"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC... your-email@example.com"

# Параметры ВМ для stage окружения (средние ресурсы)
vm_name      = "stage-vm"
vm_cores     = 4
vm_memory    = 8
vm_disk_size = 50
vm_disk_type = "network-ssd"

# Дополнительные параметры
image_family = "ubuntu-2204-lts"
zone         = "ru-central1-a"
platform_id  = "standard-v2"
nat          = true

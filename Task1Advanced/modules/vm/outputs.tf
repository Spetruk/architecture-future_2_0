# Выходные значения модуля виртуальной машины

output "vm_id" {
  description = "ID виртуальной машины"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = yandex_compute_instance.vm.name
}

output "vm_external_ip" {
  description = "Внешний IP-адрес виртуальной машины"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес виртуальной машины"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "vm_zone" {
  description = "Зона доступности виртуальной машины"
  value       = yandex_compute_instance.vm.zone
}

output "vm_platform_id" {
  description = "ID платформы виртуальной машины"
  value       = yandex_compute_instance.vm.platform_id
}

output "vm_cores" {
  description = "Количество ядер виртуальной машины"
  value       = yandex_compute_instance.vm.resources[0].cores
}

output "vm_memory" {
  description = "Объём памяти виртуальной машины"
  value       = yandex_compute_instance.vm.resources[0].memory
}

output "disk_id" {
  description = "ID диска виртуальной машины"
  value       = yandex_compute_disk.vm_disk.id
}

output "disk_name" {
  description = "Имя диска виртуальной машины"
  value       = yandex_compute_disk.vm_disk.name
}

output "disk_size" {
  description = "Размер диска виртуальной машины"
  value       = yandex_compute_disk.vm_disk.size
}

output "disk_type" {
  description = "Тип диска виртуальной машины"
  value       = yandex_compute_disk.vm_disk.type
}

output "subnet_id" {
  description = "ID подсети виртуальной машины"
  value       = yandex_compute_instance.vm.network_interface[0].subnet_id
}

output "environment" {
  description = "Окружение виртуальной машины"
  value       = var.environment
}

output "ssh_connection" {
  description = "Команда для SSH-подключения к виртуальной машине"
  value       = "ssh ubuntu@${yandex_compute_instance.vm.network_interface[0].nat_ip_address}"
}

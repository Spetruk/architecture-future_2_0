# Выходные значения для prod окружения

output "vm_id" {
  description = "ID виртуальной машины"
  value       = module.vm.vm_id
}

output "vm_name" {
  description = "Имя виртуальной машины"
  value       = module.vm.vm_name
}

output "vm_external_ip" {
  description = "Внешний IP-адрес виртуальной машины"
  value       = module.vm.vm_external_ip
}

output "vm_internal_ip" {
  description = "Внутренний IP-адрес виртуальной машины"
  value       = module.vm.vm_internal_ip
}

output "ssh_connection" {
  description = "Команда для SSH-подключения"
  value       = module.vm.ssh_connection
}

output "environment" {
  description = "Окружение"
  value       = module.vm.environment
}

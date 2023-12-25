# Outputting VM Admin user to be used as Module output

output "admin_user" {
  value = azurerm_linux_virtual_machine.linuxvm.admin_username
}

# Outputting VM Admin Password and masked it to be used as Module output
output "admin_password" {
  value     = azurerm_linux_virtual_machine.linuxvm.admin_password
  sensitive = true
}

# Outputting VM Public IP to be used as Module output
output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.linuxvm.public_ip_address
}


# Outputting Subnet ID to be used as Module output
output "subnet_id" {
  value = azurerm_subnet.subnet.id  
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
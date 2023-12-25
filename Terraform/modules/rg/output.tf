# Outputting RG Name to be used as Module output
output "rg_name" {
  value = azurerm_resource_group.rg.name
  
}
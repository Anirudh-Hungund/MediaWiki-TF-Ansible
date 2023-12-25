resource "random_string" "rg" {
  length  = 5
  special = false
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "Automation-RG-${random_string.rg.result}"
}

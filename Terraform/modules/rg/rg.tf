# This Module is used for RG module

# Creating a Random Suffix for RG Name
resource "random_string" "rg" {
  length  = 5
  special = false
}

# Creating a Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "MediaWiki-RG-${random_string.rg.result}"
}


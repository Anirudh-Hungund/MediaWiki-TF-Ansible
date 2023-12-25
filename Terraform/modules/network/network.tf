# This TF file is used as Network Module

# Creating VNET
resource "azurerm_virtual_network" "vnet" {
  address_space       = [var.address_space]
  location            = var.location
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

# Creating Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.address_space]
}




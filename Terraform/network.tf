resource "azurerm_virtual_network" "vnet" {
  address_space       = ["192.168.10.0/28"]
  location            = var.location
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_subnet" "name" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.10.0/28"]

}

resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = "${azurerm_virtual_network.vnet.name}-NSG"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule = [{
    access                                     = "Allow"
    description                                = "Allowing SSH from Internet to VirtualNetworking, this is for testing purposes, cannot be used in production"
    direction                                  = "Inbound"
    name                                       = "Allow_SSH_Inbound_Rule"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = "Internet"
    source_address_prefixes                    = []
    source_port_range                          = ""
    source_port_ranges                         = ["22"]
    source_application_security_group_ids      = []
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = ["22"]
    destination_port_range                     = ""
    destination_address_prefix                 = "VirtualNetwork"
  }]
}

resource "azurerm_subnet_network_security_group_association" "name" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.name.id

}

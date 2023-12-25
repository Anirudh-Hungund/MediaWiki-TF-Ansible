# Creating a random string as prefix for Linux VM
resource "random_string" "linux" {
  length  = 4
  special = false
}
# Creating a random Password for Linux VM
resource "random_password" "linuxpassword" {
  length           = 14
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  special          = true
  override_special = "#$=@"
}

#Creating a Azure PublicIP
resource "azurerm_public_ip" "publicip" {
  allocation_method   = "Dynamic"
  location            = var.location
  name                = "mediawiki-${random_string.linux.result}-pip"
  resource_group_name = var.rg_name
}

#Creating a Azure NIC
resource "azurerm_network_interface" "vm_nic" {
  location            = var.location
  name                = "mediawiki-${random_string.linux.result}"
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "mediawiki-${random_string.linux.result}-ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
    public_ip_address_id         = azurerm_public_ip.publicip.id
  }
}

#Creating a Azure Linux Virtual Machine for hosting MediaWiki
resource "azurerm_linux_virtual_machine" "linuxvm" {
  admin_username        = var.vm_admin_name
  location              = var.location
  name                  = "mediawiki-${random_string.linux.result}"
  network_interface_ids = ["${azurerm_network_interface.vm_nic.id}"]
  resource_group_name   = var.rg_name
  size                  = var.vm_size
  admin_password        = random_password.linuxpassword.result
  os_disk {
    caching              = "None"
    storage_account_type = "StandardSSD_LRS"
  }
  disable_password_authentication = false
  source_image_reference {
    offer     = "centos-stream-8-0-free"
    publisher = "eurolinuxspzoo1620639373013"
    sku       = "centos-stream-8-0-free"
    version   = "latest"
  }
  plan {
    name      = "centos-stream-8-0-free"
    product   = "centos-stream-8-0-free"
    publisher = "eurolinuxspzoo1620639373013"
  }
}

# Creating NSG with SSH Security Rule to allow local Public IP
resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = "${azurerm_linux_virtual_machine.linuxvm.name}-NSG"
  resource_group_name = var.rg_name

  security_rule = [{
    access                                     = "Allow"
    description                                = "Allowing SSH from Internet to VirtualNetworking, this is for testing purposes, cannot be used in production"
    direction                                  = "Inbound"
    name                                       = "Allow_SSH_Inbound_Rule"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = var.user_public_ip
    source_address_prefixes                    = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    source_application_security_group_ids      = []
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = ["22"]
    destination_port_range                     = ""
    destination_address_prefix                 = "*"
  },
    {
    access                                     = "Allow"
    description                                = "Allowing HTTP and HTTPS traffic on vm from internet"
    direction                                  = "Inbound"
    name                                       = "Allow_Web_Inbound_Rule"
    priority                                   = 101
    protocol                                   = "Tcp"
    source_address_prefix                      = "Internet"
    source_address_prefixes                    = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    source_application_security_group_ids      = []
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = ["80", "443"]
    destination_port_range                     = ""
    destination_address_prefix                 = azurerm_linux_virtual_machine.linuxvm.private_ip_address
  }
  ]
 
}

#Attaching NSG created in Network Module to be Associated to the NIC
resource "azurerm_network_interface_security_group_association" "nsg_rule" {
  network_interface_id = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
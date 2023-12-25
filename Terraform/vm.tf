resource "random_string" "linux" {
  length  = 4
  special = false
}

resource "random_password" "linuxpassword" {
  length           = 14
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  special          = true
  override_special = "(){}[]|¦!£%^&*:;#~_-+=@"
}

resource "azurerm_network_interface" "vm_nic" {
  location            = var.location
  name                = "linuxnic-${random_string.linux.result}"
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "linuxnic-${random_string.linux.result}-ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.name.id
    #public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  admin_username        = "linuxadmin"
  location              = var.location
  name                  = "linuxvm-${random_string.linux.result}"
  network_interface_ids = ["${azurerm_network_interface.vm_nic.id}"]
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_B2ms"
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
output "admin_password" {
  value     = azurerm_linux_virtual_machine.linuxvm.admin_password
  sensitive = true
}

resource "azurerm_public_ip" "publicip" {
  allocation_method   = "Dynamic"
  location            = var.location
  name                = "${azurerm_linux_virtual_machine.linuxvm.name}-pip"
  resource_group_name = azurerm_resource_group.rg.name
}

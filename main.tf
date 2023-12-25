# Getting public IP of Host where this script is running to add into the NSG Rule
data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

# RG Module
module "rg" {
  source   = "./Terraform/modules/rg"
  location = var.location
}

# Network Module
module "network" {
  source        = "./Terraform/modules/network"
  location      = var.location
  rg_name       = module.rg.rg_name
  vnet_name     = var.vnet_name
  subnet_name   = var.subnet_name
  address_space = var.address_space

}

# VM Module
module "vm" {
  source         = "./Terraform/modules/vm"
  location       = var.location
  rg_name        = module.rg.rg_name
  subnet_id      = module.network.subnet_id
  vm_size        = var.vm_size
  vm_admin_name  = var.vm_admin_name
  user_public_ip = data.external.myipaddr.result.ip
  vnet_name      = module.network.vnet_name
}

# Ansible Host Defined, which will be used by ansible to build inventory.yml file.

resource "ansible_host" "name" {
  name   = module.vm.vm_public_ip
  groups = ["all"]
  variables = {
    ansible_user               = module.vm.admin_user
    ansible_sudo_pass          = module.vm.admin_password
    ansible_ssh_pass           = module.vm.admin_password
    mysql_password             = module.vm.admin_password
    ansible_connection         = "ssh",
    ansible_python_interpreter = "/usr/bin/python3",
  }
}

output "vm_public_ip" {
  value = module.vm.vm_public_ip
   description = "The Public IP address to Browse MediaWiki"
}
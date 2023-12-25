# Varibles which will be passed to Modules in Main.TF file

variable "location" {
  default = "EastUS"
}

variable "vnet_name" {
  default = "automation-vnet"
}

variable "subnet_name" {
  default = "automation-subnet"
}

variable "address_space" {
  default = "192.168.0.0/28"
}

variable "vm_size" {
  default = "Standard_B2ms"
}

variable "vm_admin_name" {
  default = "linuxadmin"
}
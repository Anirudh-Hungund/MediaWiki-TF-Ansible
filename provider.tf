# Providers with AzureRM and Ansible, which are required
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  # client_id       = "00000000-0000-0000-000-000000000000"
  # client_secret   = "0000000000000000000000000000000000000000"
  # tenant_id       = "00000000-0000-0000-000-000000000000"
  # subscription_id = "00000000-0000-0000-000-000000000000" 
}

# Configure the Random Provider
provider "random" {}

# Configure the Ansible Provider
provider "ansible" {}




# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

    client_id       = "44b3b4b5-a07e-4e11-b18a-15db44dd896e"
    client_secret   = "bK68Q~-lfuoQkGVgMZj6IEv3KupErJz3SaP76cF."
    tenant_id       = "a7859e46-bb0b-4398-901f-041076e741d0"
    subscription_id = "ef4bec7f-bf5e-4144-aa6c-015e8f1dc2b4"
}

provider "random" {}
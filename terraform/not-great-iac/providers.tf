terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
    }
  }
}

provider "azurerm" {
  subscription_id = "673af34d-6b28-41dc-bc7b-f507418045e6"
  client_id = "00000000-0000-0000-0000-000000000000"
  client_secret = "abc00000-0000-0000-0000-000000000000"

  features {}
}


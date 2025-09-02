terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.116" }
  }
}
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "xpe_shared_poc"
  features {}
  subscription_id = "bc444e87-bfcd-4aeb-93f9-9a52b1089062"
}



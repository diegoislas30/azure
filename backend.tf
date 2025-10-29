terraform {
  backend "azurerm" {
    resource_group_name  = "XPERTAL-Shared-xcs-ti-rg"
    storage_account_name = "xpeterraformpoc"
    container_name       = "terraform-tfstate"
    # el key lo definimos en CI / init
  }
}

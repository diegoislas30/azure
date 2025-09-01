module "resource_group_1" {
  source              = "./modules/resource_group"
  resource_group_name = "rg-ejemplo"
  location            = "eastus"

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

module "resource_group_1" {
  source              = "./modules/resource_group"
  resource_group_name = "resource_group_terraform"
  location            = "South Central US"

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}
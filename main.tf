module "resource_group" {
  source = "./modules/resource_group"
  resource_group_name = "terraform-import"
  location = "eastus"
  tags = {
    UDN = "Xpertal"
    OWNER = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }
  providers = {
    azurerm = azurerm.XPERTAL-Shared-xcs
  }
}

module "resource_group_xpeterraformpoc_2" {
  source = "./modules/resource_group"
  resource_group_name = "terraform-import-2"
  location = "eastus"
  tags = {
    UDN = "Xpertal"
    OWNER = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }
  providers = {
    azurerm = azurerm.XPERTAL-Shared-xcs
  }
}
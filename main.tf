module "resource_group_xpeterraformpoc" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc-rg"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"   
}

providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}


## Recurso generado por Yam


module "resource_group_xpeterraformpoc" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc2-rg"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Guillermo Yam"
    xpeowner = "guillermo.yam@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"   
}

providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

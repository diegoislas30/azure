module "resource_group_xpe_rg_001" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-001"
  location            = "southcentralus"

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
    
  }

  providers = { azurerm = azurerm.xpe_shared_poc}

}


module "resource_group_xpe_rg_002" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-002"
  location            = "southcentralus"

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
    
  }

  providers = { azurerm = azurerm.xpe_shared_poc}

}


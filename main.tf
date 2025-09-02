module "resource_group_xpe_rg_001" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-001"
  location            = "southcentralus"

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "dislas@caabsa.com.mx"
    proyecto = "Terraform"
    ambiente = "DEV"
    
  }

  providers = { azurerm = azurerm.xpe_shared_poc}

}
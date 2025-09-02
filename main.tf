module "resource_group_xpe_rg_001" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-001"
  location            = "East US"

  tags = {
    UDN = "xpertal"
    OWNER = "Diego Islas"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "Dev"
  }

  providers = { azurerm = azurerm.xpe_shared_poc }
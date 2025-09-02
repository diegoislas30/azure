## crear el primer grupo de recursos y mandalo a llamar desde el modulo de resources group. 

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-001"
  location            = "South Central US"

  tags = {
    UDN = "Xpertal"
    OWNER = "Diego Enrique Islas"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Poc Terraform"
    ambiente = "DEV"
  }
  
}

  
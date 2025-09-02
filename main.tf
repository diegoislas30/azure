module "resource_group_xpe_rg_001" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-001"
  location            = "southcentralus"

  tags = {
    UDN         = "Xpertal"
    OWNER       = "Diego Islas"
    xpeowner    = "diegoenrique.islas@xpertal.com"
    proyecto    = "Terraform"
    ambiente    = "Dev"
  
  }
}
    
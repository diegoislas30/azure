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
}
module "rg_terraform_vm" {
  source              = "./modules/resource_group"
  resource_group_name = "rg-terraform-vm"
  location            = "southcentralus"

    tags = {
        UDN      = "Xpertal"
        OWNER    = "Diego Enrique Islas Cuervo"
        xpeowner = "diegoenrique.islas@xpertal.com"
        proyecto = "terraform-vm"
        ambiente = "dev"
    }
}
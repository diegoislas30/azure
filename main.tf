module "resource_group_terraform" {
  source   = "./modules/resource_group"
  resource_group_name = "rg-terraform-vm"
  location = "southcentralus"
  
    tags = {
        UDN = "Xpertal"
        OWNER = "Diego Enrique Islas Cuervo"
        xpeowner = "diegoenrique.islas@xpertal.com"
        environment = "dev"
        project = "Terraform"
    }

    providers = {
      azurerm = azurerm.xpe_shared_poc
    }
}




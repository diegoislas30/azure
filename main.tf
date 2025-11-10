
module "rg-scxpeicmprd" {
   source = "./modules/resource_group"

   resource_group_name = "rg-scxpeicmprd"
   location            = "southcentralus"

   tags = {
     UDN      = "Xpertal"
     OWNER    = "Martha Ibarra"
     xpeowner = "martha.ibarra@xpertal.com"
     proyecto = "ICM"
     ambiente = "Productivo"
   }

   providers = {
     alias   = azurerm.Xpertal_XCS

   }

}



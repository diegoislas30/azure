
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
     azurerm = azurerm.Xpertal_XCS
   }
 }


# Para importar el resource group definido por el módulo, ejecutar en terminal:
# terraform import module.rg-scxpeicmprd.azurerm_resource_group.this /subscriptions/6d94fbd2-8182-4943-a9b3-53d236df5469/resourceGroups/rg-scxpeicmprd
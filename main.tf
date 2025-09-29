module "resource_group_xpeterraformpoc" {
    source = "./modules/resource_group"

    resource_group_name = "xpeterraformpoc-rg"
    location            = "southcentralus"

    tags = {
        UDN      = "Xpertal"
        OWNER    = "Diego Enrique Islas Cuervo"
        xpeowner = "diegoenrique.islas@xpertal.com"
        proyecto = "terraform"
        ambiente = "dev"
    }

    providers = {
        azurerm = azurerm.xpe_shared_poc
    }
}


## == Ejemplo de declarar el modulo de vnet sin peerings ni delegaciones ==
module "vnet_simple" {
  source              = "./modules/vnets"
  vnet_name           = "vnet-simple"
  location            = module.resource_group_xpeterraformpoc.resource_group_location
  resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
  address_space       = ["10.10.0.0/16"]

  subnets = [
    {
      name           = "servidores"
      address_prefix = "10.10.1.0/24"
    },
    {
      name           = "app"
      address_prefix = "10.10.2.0/24"
    }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Islas"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}
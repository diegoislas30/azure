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


## Recurso generado por Yam


module "resource_group_xpeterraformpoc2" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc2-rg"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Guillermo Yam"
    xpeowner = "guillermo.yam@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

## Recurso generado pedro 


module "resource_group_xpeterraformpoc3" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc3-rg"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Pedro Guerrero"
    xpeowner = "pedrojulio.guerrero@xpertal.com"
    proyecto = "terraform"
    ambiente = "QA"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}


module "vnet_simple" {
  source = "./modules/vnets"

  vnet_name           = "simple-vnet"
  resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
  location            = module.resource_group_xpeterraformpoc.resource_group_location
  address_space       = ["20.0.0.0/16"]
  subnets = [
    {
      name           = "subnet-01"
      address_prefix = "20.0.10.0/24"
    },
    {
      name           = "subnet-02"
      address_prefix = "20.0.20.0/24"
    }

  ]
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "dislas@caabsa.com.mx"
    proyecto = "terraform"
    ambiente = "dev"
  }
  providers = {
    azurerm = azurerm.xpe_shared_poc
  }

}


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

## Recurso generado por Pedro
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

# === Network Security Group ===
# module "network_security_group" {
#   source = "./modules/network_security_group"
#
#   nsg_name            = "xpeterraformpoc-nsg"
#   resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
#   location            = module.resource_group_xpeterraformpoc.resource_group_location
#
#   security_rules = [
#     {
#       name                       = "Allow-HTTP"
#       priority                   = 100
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "80"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     },
#     {
#       name                       = "Allow-HTTPS"
#       priority                   = 110
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "443"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   ]
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Enrique Islas Cuervo"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
#
# }

# === Virtual Network ===

# module "vnet_xpeterraformpoc" {
#   source = "./modules/vnets"
#
#   vnet_name           = "xpeterraformpoc-vnet"
#   location            = module.resource_group_xpeterraformpoc.resource_group_location
#   resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
#   address_space       = ["20.0.0.0/16"]
#   subnets = [
#     {
#       name           = "default"
#       address_prefix = "20.0.10.0/24"
#     },
#     {
#       name           = "web"
#       address_prefix = "20.0.20.0/24"
#     },
#     {
#       name           = "app"
#       address_prefix = "20.0.30.0/24"
#     }
#
#   ]
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Enrique Islas Cuervo"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

module "xpertal_network_security_group" {
  source = "./modules/network_security_group"

  nsg_name            = "xpertal-nsg"
  resource_group_name = module.resource_group_xpeterraformpoc2.resource_group_name
  location            = module.resource_group_xpeterraformpoc2.resource_group_location

  security_rules = [
    {
      name                       = "Allow-HTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTPS"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

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


module "vnet_xpeterraformpoc" {
  source = "./modules/vnets" # Ruta a tu módulo corregido

  vnet_name           = "xpeterraformpoc-vnet"
  resource_group_name = azurerm_resource_group.rg.resource_group_name
  location            = azurerm_resource_group.rg.resource_group_location
  address_space       = ["10.0.0.0/16"]

  # Lista de subnets que se deben crear
  subnets = [
    {
      name           = "web"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "app" # Esta subnet no tendrá NSG
      address_prefix = "10.0.2.0/24"
    }
  ]

  # ✨ Aquí se define qué subnet se asocia con qué NSG ✨
  # Se construye el mapa que se pasa a la variable 'subnet_nsg_associations'.
  # Como solo 'web' está en este mapa, solo esa subnet se asociará.
  subnet_nsg_associations = {
    "web" = azurerm_network_security_group.web_nsg.id
  }

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



## == Ejemplo de declarar el modulo de resource group ==

# module "resource_group_xpeterraformpoc" {
#   source = "./modules/resource_group"
#
#   resource_group_name = "xpeterraformpoc-rg"
#   location            = "southcentralus"
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

## =================================================================== ## 


## == Ejemplo de declarar el modulo de network security group ==


# module "network_security_group" {
#   source              = "./modules/network_security_group"
#   nsg_name            = "xpeterraformpoc2-nsg"
#   resource_group_name = module.resource_group_xpeterraformpoc2.resource_group_name
#   location            = module.resource_group_xpeterraformpoc2.resource_group_location
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
#     OWNER    = "Guillermo Yam"
#     xpeowner = "guillermo.yam@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

## =================================================================== ##

## == Ejemplo de como asociar un NSG a un subnet ==

# Asocia un Grupo de Seguridad de Red (NSG) con la subred "web" en la red virtual especificada.
# - Utiliza la configuración del proveedor `azurerm.xpe_shared_poc`.
# - El ID de la subred se obtiene de la salida del módulo `vnet_xpeterraformpoc2` para la subred "web".
# - El ID del NSG se obtiene de la salida del módulo `network_security_group`.

# resource "azurerm_subnet_network_security_group_association" "web_assoc" {
#  provider                  = azurerm.xpe_shared_poc
# subnet_id                 = module.vnet_xpeterraformpoc2.subnet_ids["web"]
#  network_security_group_id = module.network_security_group.nsg_id
# }

## ================================================================== ##


## == Ejemplo de declarar el modulo de route table ==


# module "route_table" {
#   source = "./route_table"
#
#   rt_name             = "xpeterraformpoc2-rt"
#   resource_group_name = module.resource_group_xpeterraformpoc2.resource_group_name
#   location            = module.resource_group_xpeterraformpoc2.resource_group_location
#   routes = [
#     {
#       name                   = "route-to-internet"
#       address_prefix         = "0.0.0.0/0"
#       next_hop_type          = "Internet"
#       next_hop_in_ip_address = null
#     }
#   ]
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Guillermo Yam"
#     xpeowner = "guillermo.yam@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

## =================================================================== ##

## == Ejemplo de como asociar la route table a una subnet ==

# Asocia la subred especificada con una tabla de rutas en Azure.
# - Utiliza la configuración del proveedor `azurerm.xpe_shared_poc`.
# - `subnet_id`: Hace referencia a la subred "app" del módulo `vnet_xpeterraformpoc2`.
# - `route_table_id`: Hace referencia al ID de la tabla de rutas del módulo `route_table`.

# resource "azurerm_subnet_route_table_association" "web_rt_assoc" {
#   provider       = azurerm.xpe_shared_poc
#   subnet_id      = module.vnet_xpeterraformpoc2.subnet_ids["app"]
#   route_table_id = module.route_table.rt_id
# }

## =================================================================== ##

## == Ejemplo de declarar el modulo de vnet sin peerings ni delegaciones ==
# module "vnet_simple" {
#   source              = "./modules/vnets"
#   vnet_name           = "vnet-simple"
#   location            = module.resource_group_xpeterraformpoc.resource_group_location
#   resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
#   address_space       = ["10.10.0.0/16"]
#
#   subnets = [
#     {
#       name           = "web"
#       address_prefix = "10.10.1.0/24"
#     },
#     {
#       name           = "app"
#       address_prefix = "10.10.2.0/24"
#     }
#   ]
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Islas"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

## =================================================================== ##


##############################################
# Resource Groups
##############################################


# =========================
# Resource Group Hub
# =========================

# module "resource_group_hub" {
#   source = "./modules/resource_group"
#
#   resource_group_name = "xpeterraformpoc-hub-rg"
#   location            = "southcentralus"
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
#
# module "resource_group_spoke" {
#   source = "./modules/resource_group"
#
#   resource_group_name = "xpeterraformpoc-spoke-rg"
#   location            = "southcentralus"
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Enrique Islas Cuervo"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

##############################################

##############################################

# Virtual Networks

# =========================

# module "vnet_hub" {
#   source              = "./modules/vnets"
#   vnet_name           = "xpeterraformpoc-hub-vnet"
#   location            = module.resource_group_hub.resource_group_location
#   resource_group_name = module.resource_group_hub.resource_group_name
#   address_space       = ["10.100.0.0/16"]
#
#     subnets = [
#     {
#       name           = "functions"
#       address_prefix = "10.100.1.0/24"
#       delegation = {
#         name = "delegate-functions"
#         service_delegation = {
#           name    = "Microsoft.Web/serverFarms"
#           actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#         }
#       }
#     },
#
#     {
#       name           = "prueba"
#       address_prefix = "10.100.2.0/24"
#     }
#
#   ]
#
#   peerings = [
#     {
#       name               = "hub-to-spoke"
#       remote_vnet_id     = module.vnet_spoke.vnet_id
#       remote_vnet_name   = module.vnet_spoke.vnet_name
#       remote_rg_name     = module.resource_group_spoke.resource_group_name
#
#       local = {
#         allow_virtual_network_access = true
#         allow_forwarded_traffic      = true
#         allow_gateway_transit        = false
#         use_remote_gateways          = false
#       }
#
#       remote = {
#         allow_virtual_network_access = true
#         allow_forwarded_traffic      = true
#         allow_gateway_transit        = false
#         use_remote_gateways          = false
#       }
#     }
#   ]
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Islas"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "qa"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }
#
# module "vnet_spoke" {
#   source              = "./modules/vnets"
#   vnet_name           = "xpeterraformpoc-spoke-vnet"
#   location            = module.resource_group_spoke.resource_group_location
#   resource_group_name = module.resource_group_spoke.resource_group_name
#   address_space       = ["20.0.0.0/16"]
#
#     subnets = [
#     {
#       name           = "app"
#       address_prefix = "20.0.10.0/24"
#     },
#
#     {
#       name           = "db"
#       address_prefix = "20.0.20.0/24"
#     }
#
#     ]
#
# tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Islas"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "qa"
#     }
#
#     providers = {
#         azurerm = azurerm.xpe_shared_poc
#     }
#
# }
#
# module "network_security_group_hub" {
#   source              = "./modules/network_security_group"
#   nsg_name            = "xpeterraformpoc-hub-nsg"
#   resource_group_name = module.resource_group_hub.resource_group_name
#   location            = module.resource_group_hub.resource_group_location
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
#     },
#
#     {
#         name                       = "Allow-AzureLoadBalancer"
#         priority                   = 120
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "*"
#         source_port_range          = "*"
#         destination_port_range     = "*"
#         source_address_prefix      = "AzureLoadBalancer"
#         destination_address_prefix = "*"
#     }
#     ## Aqui cierro reglas
#   ]
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Islas"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "qa"
#     }
#
#     providers = {
#         azurerm = azurerm.xpe_shared_poc
#     }
# }
#
#
# resource "azurerm_subnet_network_security_group_association" "prueba_assoc" {
#   provider                  = azurerm.xpe_shared_poc
#   subnet_id                 = module.vnet_hub.subnet_ids["prueba"]
#   network_security_group_id = module.network_security_group_hub.nsg_id
# }

module "resource_group" {
  source = "./modules/resource-group"

  # Si este RG está en tu suscripción con alias, descomenta:
  # providers = { azurerm = azurerm.xpe_shared_poc }

  rgs = {
    terraform-import-test = {
      name     = "terraform-import-test"
      location = "southcentralus"
      tags = {
        UDN       = "Xpertal"
        OWNER     = "Diego Enrique Islas Cuervo"
        xpeowner  = "diegoenrique.islas@xpertal.com"
        proyecto  = "terraform"
        ambiente  = "dev"
      }
    }
  }
  
  providers = {
    azurerm = azurerm.xpe_shared_poc
  }

}


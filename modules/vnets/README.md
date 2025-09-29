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


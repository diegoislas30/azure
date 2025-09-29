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
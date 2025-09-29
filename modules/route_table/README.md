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

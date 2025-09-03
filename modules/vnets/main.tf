## Genera el archivo main.tf para el módulo vnets, donde se definen las redes virtuales y subredes en Azure, así como las asociaciones de las tablas de rutas y los peering.
## Las opciones de los nsg, peering de tablas de ruteo tiene que ser opcionales.

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = tomap(var.tags)
  dns_servers         = var.dns_servers
  
}

resource "azurerm_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints   = lookup(each.value, "service_endpoints", null)
  private_endpoint_network_policies = lookup(each.value, "private_endpoint_network_policies", null)

  depends_on = [
    azurerm_virtual_network.this
  ]
}

resource "azurerm_route_table" "this" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = tomap(var.tags)
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = { for assoc in var.subnet_route_table_associations : "${assoc.subnet_name}-${assoc.route_table_name}" => assoc }

  subnet_id      = azurerm_subnet.this[each.value.subnet_name].id
  route_table_id = azurerm_route_table.this[each.value.route_table_name].id
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = { for peer in var.vnet_peerings : peer.name => peer }

  name                      = each.value.name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", false)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", false)

}


#############################################
# Virtual Network
#############################################
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = tomap(var.tags)
}

#############################################
# Subnets dinámicas
#############################################
resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies", true)
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for k, v in var.subnets : k => v if try(v.nsg_id, null) != null
  }
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for k, v in var.subnets : k => v if try(v.route_table_id, null) != null
  }
  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}

#############################################
# VNET Peerings (opcionales)
#############################################
# Crea 1 recurso de peering por cada entrada en var.peerings
resource "azurerm_virtual_network_peering" "this" {
  for_each                    = { for p in var.peerings : p.name => p }

  name                        = each.value.name
  resource_group_name         = var.resource_group_name
  virtual_network_name        = azurerm_virtual_network.this.name

  remote_virtual_network_id   = each.value.remote_virtual_network_id

  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, true)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)
}

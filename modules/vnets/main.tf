resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])

  private_link_service_network_policies_enabled  = lookup(each.value, "private_link_service_network_policies", true)
}

# (opcionales) asociaciones si pasas IDs
resource "azurerm_subnet_network_security_group_association" "nsg" {
  for_each = { for k, v in var.subnets : k => v if try(v.nsg_id, null) != null }
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id
}

resource "azurerm_subnet_route_table_association" "rt" {
  for_each = { for k, v in var.subnets : k => v if try(v.route_table_id, null) != null }
  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}

# === VNET ===
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

# === Subnets ===
resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = lookup(each.value, "delegations", [])
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}

# === Asociación NSG → Subnet (count) ===
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = { for s in var.subnets : s.name => s }

  count = try(each.value.nsg_id, null) == null ? 0 : 1

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id
}

# === Asociación Route Table → Subnet (count) ===
resource "azurerm_subnet_route_table_association" "this" {
  for_each = { for s in var.subnets : s.name => s }

  count = try(each.value.route_table_id, null) == null ? 0 : 1

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}

# === Peerings opcionales ===
resource "azurerm_virtual_network_peering" "this" {
  for_each = { for p in var.peerings : p.name => p }

  name                      = each.value.name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_vnet_id

  allow_virtual_network_access = lookup(each.value, "allow_vnet_access", true)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", false)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", false)
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}

# Asociar NSG si se especifica en la variable
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for s in var.subnets : s.name => s
    if contains(keys(s), "nsg_id") && s.nsg_id != null && s.nsg_id != ""
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id
}

# Asociar Route Table si se especifica en la variable
resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for s in var.subnets : s.name => s
    if contains(keys(s), "route_table_id") && s.route_table_id != null && s.route_table_id != ""
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}

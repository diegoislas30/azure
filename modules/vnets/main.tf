resource "azurerm_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}

# 👇 Asociación de NSG a subnets (opcional si viene el ID en la variable)
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for s in var.subnets : s.name => s
    if try(s.network_security_group_id, null) != null
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

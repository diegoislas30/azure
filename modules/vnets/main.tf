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

# 🚀 Aquí la clave: solo iteramos las subnets que tengan NSG
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for s in var.subnets : s.name => s.network_security_group_id
    if s.network_security_group_id != null && s.network_security_group_id != ""
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}

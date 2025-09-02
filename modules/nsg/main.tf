resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = tomap(var.tags)
}

resource "azurerm_network_security_rule" "this" {
  for_each                    = { for r in var.rules : r.name => r }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  description                 = try(each.value.description, null)

  source_port_range           = try(each.value.source_port_range, null)
  destination_port_range      = try(each.value.destination_port_range, null)
  destination_port_ranges     = try(each.value.destination_port_ranges, null)

  source_address_prefix          = try(each.value.source_address_prefix, null)
  source_address_prefixes        = try(each.value.source_address_prefixes, null)
  destination_address_prefix     = try(each.value.destination_address_prefix, null)
  destination_address_prefixes   = try(each.value.destination_address_prefixes, null)
}

# Asociaciones opcionales
resource "azurerm_subnet_network_security_group_association" "subnet" {
  for_each = toset(var.associate_subnet_ids)
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface_security_group_association" "nic" {
  for_each = toset(var.associate_nic_ids)
  network_interface_id      = each.value
  network_security_group_id = azurerm_network_security_group.this.id
}

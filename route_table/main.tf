resource "azurerm_route_table" "this" {
  name                = var.rt_name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }

  tags = tomap(var.tags)
}

output "rt_id" {
  value = azurerm_route_table.this.id
}

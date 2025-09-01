resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name   # ✅ bien escrito
  location = var.location
}

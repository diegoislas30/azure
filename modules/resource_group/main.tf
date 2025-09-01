resource "azurerm_resource_group" "this" {
  name     = var.resourece_group_name
  location = var.location
}

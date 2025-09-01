resource "azurerm_resource_group" "rg" {
  name     = var.resourece_group_name
  location = var.location
  tags = var.tags
}


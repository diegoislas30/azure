resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.vnet.resource_group_name
  address_space       = var.address_space

  subnet {
    name = var.subnet_name
    address_prefix = var.address_prefix
  }
}

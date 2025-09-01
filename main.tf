module "resource_group" {
  source = "./modules/resource_group"
  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
  resourece_group_name = "my-resource-group"
  location             = "South Central US"
  tags = {
    environment = "production"
    project     = "my-project"
  }
}


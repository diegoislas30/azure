module "resource_group_1" {
  source              = "./modules/resource_group"
  resource_group_name = "rg-ejemplo"
  location            = "eastus"

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

module "vnet_1" {
  source              = "./modules/vnets"
  vnet_name           = "vnet-ejemplo"
  resource_group_name = module.resource_group_1.name
  location            = module.resource_group_1.location
  address_space       = ["20.0.0.0/16"]

  subnets = {
    subnet1 = {
      address_prefix    = "20.0.10.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  }

  tags = {
    environment = "poc"
    project     = "xpertal"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc # 🔐 usa el mismo alias que el RG
  }
}

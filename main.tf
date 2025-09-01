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
  # manda a llamar el nombre del resource group creado en el modulo resource_group_1
  resource_group_name = module.resource_group_1.resource_group_name
  location            = module.resource_group_1.resource_group_location
  address_space       = ["20.0.0.0/16"]
  dns_servers         = []
  tags                = {
    environment = "poc"
    project     = "xpe"
  }

  
  subnets = {
    subnet1 = {
      address_prefix    = "20.0.10.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }

  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }

  depends_on = [module.resource_group_1]


}




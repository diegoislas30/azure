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
  resource_group_name = module.resource_group_1.resource_group_name
  location            = module.resource_group_1.resource_group_location
  address_space       = ["20.0.0.0/16"]
  dns                 = []
  tags                = {
    environment = "poc"
    project     = "xpertal"

  }

  subnets = {
    subnet1 = {
      address_prefix = "20.0.10.0/24"
      nsg_id         = null
      route_table_id = null
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }

    subnet2 = {
      address_prefix = "20.0.20.0/24"
      nsg_id         = null
      route_table_id = null
      service_endpoints = []
    }
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }

  depends_on = [module.resource_group_1]

}

output "vnet_1_id" {
  value       = module.vnet_1.vnet_id
  description = "ID de la VNET creada"
}

output "subnet1_id" {
  value       = module.vnet_1.subnet_ids["subnet1"]
  description = "ID de la subnet1"
}


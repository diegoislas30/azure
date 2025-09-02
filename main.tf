module "resource_group_xpe_rg_001" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-001"
  location            = "southcentralus"

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
    
  }

  providers = { azurerm = azurerm.xpe_shared_poc}

}


module "resource_group_xpe_rg_002" {
  source              = "./modules/resource_group"
  resource_group_name = "xpe-rg-002"
  location            = "southcentralus"

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
    
  }

  providers = { azurerm = azurerm.xpe_shared_poc}

}

module "vnet_xpe_vnet_001" {
  source              = "./modules/vnets"
  vnet_name           = "xpe-vnet-001"
  resource_group_name = "module.resource_group_xpe_rg_001.resource_group_name"
  location            = "module.resource_group_xpe_rg_001.resource_group_location"

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
  }

  address_space = ["10.0.0.0/16"]

  subnets = {
    frontend = {
      address_prefix = "10.0.1.0/24"
      service_endpoints = ["Microsoft.Storage"]
      nsg_id = null
      route_table_id = null
      private_endpoint_network_policies = true
      private_link_service_network_policies = true
      service_endpoints = ["Microsoft.Storage"]

    }
  }
}

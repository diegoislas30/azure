module "resource_group_1" {
  source              = "./modules/resource_group"
  resource_group_name = "xpeterraformpoc"
  location            = "southcentralus"

  tags = {
    UDN       = "udn-001"
    OWNER     = "diego.islas"
    xpeowner  = "equipo-xpe"
    proyecto  = "xpertal"
    ambiente  = "poc"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

module "vnet_xpeteraform_poc" {
  source              = "./modules/vnets"
  vnet_name           = "xpeteraformpoc-vnet"
  resource_group_name = module.resource_group_1.resource_group_name
  location            = module.resource_group_1.resource_group_location
  address_space       = ["20.0.0.0/16"]
  dns_servers         = []
  tags = {
    UDN       = "udn-001"
    OWNER     = "diego.islas"
    xpeowner  = "equipo-xpe"
    proyecto  = "xpertal"
    ambiente  = "poc"
  }

  subnets = {
    subnet-01 = {
      address_prefix = "20.0.10.0/24"
      nsg_id         = null
      route_table_id = null
      service_endpoints = []
    }

    subnet-02 = {
      address_prefix = "20.0.20.0/24"
      nsg_id         = null
      route_table_id = null
      service_endpoints = []
    }
  
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }

}




#comentario de prueba
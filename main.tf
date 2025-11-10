module "rg-scxpeicmprd" {
  source = "./modules/resource_group"
  resource_group_name = "rg-scxpeicmprd"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Martha Ibarra"
    xpeowner = "martha.ibarra@xpertal.com"
    proyecto = "ICM"
    ambiente = "Productivo"
  }
  providers = {
    azurerm = azurerm.Xpertal_XCS
  }
}

 module "vnetxpeicm-prd" {
   source              = "./modules/vnets"
   vnet_name           = "vnetxpeicm-prd"
   location            = module.rg-scxpeicmprd.resource_group_location
   resource_group_name = module.rg-scxpeicmprd.resource_group_name
   address_space       = ["172.29.80.160/27"]

   subnets = [  

      {
        name           = "snet-xpeicm-prd"
        address_prefix = "172.29.80.160/27"
        service_endpoints = []
        delegations       = []
        private_endpoint_network_policies_enabled = false
      }
   ]

    tags = {
      UDN      = "Xpertal"
      OWNER    = "Martha Ibarra"
      xpeowner = "martha.ibarra@xpertal.com"
      proyecto = "ICM"
      ambiente = "Productivo"
    }

    providers = {
      azurerm = azurerm.Xpertal_XCS
    }
 }

module "xpe-vneticmsqlmidb-prd" {
   source              = "./modules/vnets"
   vnet_name           = "xpe-vneticmsqlmidb-prd"
   location            = module.rg-scxpeicmprd.resource_group_location
   resource_group_name = module.rg-scxpeicmprd.resource_group_name
   address_space       = ["172.29.80.192/27"]

   subnets = [  

      {
        name           = "snet-xpeicm-prd"
        address_prefix = "172.29.80.192/27"
        service_endpoints = []
        delegations       = []
        private_endpoint_network_policies_enabled = false
      }
   ]

    tags = {
      UDN      = "Xpertal"
      OWNER    = "Martha Ibarra"
      xpeowner = "martha.ibarra@xpertal.com"
      proyecto = "ICM"
      ambiente = "Productivo"
    }

    providers = {
      azurerm = azurerm.Xpertal_XCS
    }
 }
   


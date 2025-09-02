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
  resource_group_name = module.resource_group_xpe_rg_001.resource_group_name
  location            = module.resource_group_xpe_rg_001.resource_group_location
  address_space       = ["10.0.0.0/16"]
  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
  }
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
  providers = { azurerm = azurerm.xpe_shared_poc}
}


module "network_security_group_xpe_nsg_001" {
  source              = "./modules/network_security_group"
  nsg_name            = "xpe-nsg-001"
  resource_group_name = module.resource_group_xpe_rg_001.resource_group_name
  location            = module.resource_group_xpe_rg_001.resource_group_location

  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"

    rules = {
      allow_ssh_from_internet = {
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      
  }

  

  }

  providers = { azurerm = azurerm.xpe_shared_poc}

  }


}


module "virtual_machine_xpe_vm_001" {
  source              = "./modules/virtual-machine"
  vm_name             = "xpe-vm-001"
  resource_group_name = module.resource_group_xpe_rg_001.resource_group_name
  location            = module.resource_group_xpe_rg_001.resource_group_location
  subnet_id           = module.vnet_xpe_vnet_001.subnet_ids["frontend"]
  vm_size             = "Standard_B1s"
  admin_username      = "guestfemsa"
  os_disk_size_gb     = 127
  data_disks          = []
  allow_rdp_from_cidr = null
  tags = {
    UDN = "Xpertal"
    OWNER     = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "Terraform"
    ambiente = "DEV"
  }
  providers = { azurerm = azurerm.xpe_shared_poc}
}

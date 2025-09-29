module "resource_group_xpeterraformpoc" {
  source              = "./modules/resource_group"
  resource_group_name = "xpeterraformpoc-rg"
  location            = "southcentralus"
  tags = {
    UDN = "XPERTAL"
    OWNER = "PEDRO JULIO "
    xpeowner = "PEDRO JULIO "
    proyecto = "terraform"
    ambiente = "poc"
  }
  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

module "vnet_simple" {
  source              = "./modules/vnets"
  vnet_name           = "vnet-simple"
  location            = module.resource_group_xpeterraformpoc.resource_group_location
  resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
  address_space       = ["10.10.0.0/16"]

  subnets = [
    {
      name           = "servidores"
      address_prefix = "10.10.1.0/24"
    },
    {
      name           = "app"
      address_prefix = "10.10.2.0/24"
    }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Islas"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }


  }
  
  module "virtual_machine_web" {
  source              = "./modules/virtual_machine"
  vm_name             = "vm-web-01"
  resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
  location            = module.resource_group_xpeterraformpoc.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "windows"
  vm_size       = "Standard_DS2_v2"
  security_type = "Standard"  # usa TrustedLaunch solo si la imagen es Gen2

  # ID de la VERSIÓN SIG (termina en /versions/x.y.z)
  source_image_id = "/subscriptions/9442ead9-7f87-4f7a-b248-53e511abefd7/resourceGroups/rg-ImageTemplate_Xpertal/providers/Microsoft.Compute/galleries/XpertalSharedImageWindows/images/Windows_2022/versions/1.0.0"

  admin_username = var.admin_username
  admin_password = var.admin_password

  data_disks = [{ lun = 0, size_gb = 40 }]

  tags = {
    UDN="Xpertal", OWNER="Equipo Infra", xpeowner="diego@xpertal.com", proyecto="terraform", ambiente="dev"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}


  



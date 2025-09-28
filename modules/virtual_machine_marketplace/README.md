# Ejemplo de como declarar el modulo virtual_machine_marketplace en el archivo main.tf root 

module "virtual_machine_web" {
  source              = "./modules/virtual_machine_marketplace". 

  vm_name             = "vm-import-01".  
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type        = "windows"
  vm_size        = "Standard_DS2_v2"
  security_type  = "Standard"

  marketplace_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"      # usa "2019-datacenter-g2" si vas a TrustedLaunch
    version   = "latest"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  data_disks = [
    { lun                  = 0, 
      size_gb              = 40, 
      caching              = "ReadOnly", 
      storage_account_type = "StandardSSD_LRS" }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Equipo Infra"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = { azurerm = azurerm.xpe_shared_poc }
}


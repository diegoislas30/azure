## == Ejemplo de declarar el modulo de virtual machine usando imagen compartida (Shared Image Gallery) ==

# module "virtual_machine_web" {
#   source = "./modules/virtual_machine"
#
#   vm_name             = "vm-import-01"
#   resource_group_name = module.resource_group.resource_group_name
#   location            = module.resource_group.resource_group_location
#   vm_size             = "Standard_DS2_v2"
#   os_type             = "windows"              # <-- minúsculas
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#
#   subnet_id = module.vnet_simple.subnet_ids["servidores"]
#
#   data_disks = [
#     {
#       lun                  = 0
#       size_gb              = 40                # <-- antes era disk_size_gb
#       caching              = "ReadOnly"
#       storage_account_type = "StandardSSD_LRS"
#     }
#   ]
#
#   security_type   = "Standard"          # <-- mayúsculas
#   source_image_id = "/subscriptions/9442ead9-7f87-4f7a-b248-53e511abefd7/resourceGroups/rg-ImageTemplate_Xpertal/providers/Microsoft.Compute/galleries/XpertalSharedImageWindows/images/Windows_2019"
#   
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Equipo Infra"
#     xpeowner = "diegoenrique.islas@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

## =================================================================== ##



# el modulo de virtual machine ==

# module "virtual_machine_web" {
#   source = "./modules/virtual_machine"
#
#   vm_name             = "xpeterraformpoc-web-01"
#   resource_group_name = module.resource_group_xpeterraformpoc2.resource_group_name
#   location            = module.resource_group_xpeterraformpoc2.resource_group_location
#   vm_size             = "Standard_DS2_v2"
#   # os_type es opcional; por defecto se aprovisiona Windows.
#   # os_type             = "windows"
#   admin_username      = "azureuser"
#   admin_password      = "C0mpleja!1234"
#
#   subnet_id = module.vnet_xpeterraformpoc2.subnet_ids["web"]
#
#   # Las VMs nacen sin IP pública; habilita esta bandera solo si es necesario.
#   enable_public_ip = false
#
#   network_security_group_id = module.network_security_group.nsg_id
#
#   data_disks = [
#     {
#       name                 = "xpeterraformpoc-web-01-data01"
#       lun                  = 0
#       caching              = "ReadOnly"
#       storage_account_type = "Premium_LRS"
#       disk_size_gb         = 256
#     }
#   ]
#
#   # Opcional: ajusta los parámetros de Trusted Launch si necesitas valores distintos.
#   secure_boot_enabled = true
#   vtpm_enabled        = true
#   security_type       = "TrustedLaunch"
#
#   source_image_id = "/subscriptions/<SUB_SIG>/resourceGroups/<RG_SIG>/providers/Microsoft.Compute/galleries/<GALLERY>/images/<IMAGE>/versions/<VERSION>"
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Equipo Infra"
#     xpeowner = "infra@xpertal.com"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }

## ===========================

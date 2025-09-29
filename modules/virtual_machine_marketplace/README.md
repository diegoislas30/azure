virtual_machine_marketplace
Módulo de Terraform para crear máquinas virtuales de Azure usando imágenes de Azure Marketplace (publisher/offer/sku/version), sin IP pública, sin NSG en la NIC/VM (se asume NSG a nivel subnet), con Trusted Launch (opcional), OS disk parametrizable y data disks gestionados adjuntos.
Permite IP privada dinámica o estática.
Características
VM Linux o Windows (os_type).
Imagen desde Marketplace vía marketplace_image { publisher, offer, sku, version }.
Trusted Launch activable (requiere imágenes Gen2 y tamaños compatibles).
Sin IP pública y sin NSG en NIC/VM (el NSG debe estar en la subnet).
IP privada dinámica o estática.
OS Disk: tamaño, caching, SKU (por defecto StandardSSD_LRS, 128 GB).
Data Disks: N discos gestionados (Managed Disks) + attachments por LUN.
Availability Zone opcional (zone = "1"|"2"|"3").
Accelerated Networking opcional (si el tamaño/región lo soporta).
Soporta tags (objeto requerido con tus 5 claves).
Requisitos
Provider azurerm >= 3.116 (probado con 3.117.x).
Credenciales con permisos para crear:
Microsoft.Compute/virtualMachines/*
Microsoft.Network/networkInterfaces/*
Microsoft.Compute/disks/*
La subnet debe existir y tener (si aplica) el NSG asociado a nivel de subnet.
Si usas TrustedLaunch:
Imagen Gen2 (en Marketplace suele ser *-g2).
Tamaño de VM compatible (p. ej., series Dv5/Ev5/Bsv2 también soportan Gen2).
Entradas principales
Nombre	Tipo	Default	Descripción
vm_name	string	–	Nombre de la VM (único en el RG).
resource_group_name	string	–	Resource Group destino.
location	string	–	Región (ej. southcentralus).
subnet_id	string	–	ID de la subnet (la NIC nace sin IP pública).
os_type	string	–	"linux" o "windows".
vm_size	string	"Standard_B1s"	Tamaño de la VM.
zone	string|null	null	Availability Zone ("1", "2", "3").
security_type	string	"TrustedLaunch"	"TrustedLaunch" o "Standard".
marketplace_image	object	–	{ publisher, offer, sku, version } (usar "latest" permitido).
admin_username	string	"spyderadmin"	Usuario admin.
admin_password	string (sens.)	–	Contraseña admin.
os_disk_size_gb	number	128	Tamaño OS disk (GB).
os_disk_storage_account_type	string	"StandardSSD_LRS"	SKU del OS disk.
os_disk_caching	string|null	null → RW	None | ReadOnly | ReadWrite.
data_disks	list(object)	[]	[{ lun, size_gb, caching?, storage_account_type? }].
enable_accelerated_networking	bool	false	NIC Accelerated Networking.
boot_diagnostics_storage_uri	string|null	null	URI de Storage para boot diagnostics.
tags	object	–	{ UDN, OWNER, xpeowner, proyecto, ambiente }.
private_ip_version	string	"IPv4"	"IPv4" o "IPv6".
private_ip_allocation	string	"Dynamic"	"Dynamic" o "Static".
private_ip_address	string|null	null	Requerida si private_ip_allocation="Static".
Salidas
vm_id – ID de la VM creada.
vm_name – Nombre de la VM.
nic_id – ID de la NIC principal.
private_ip – IP privada asignada a la NIC.
Ejemplos de uso
1) Windows desde Marketplace (IP dinámica)

module "virtual_machine_web" {
  source              = "./modules/virtual_machine_marketplace"

  vm_name             = "vm-web-01"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "windows"
  vm_size       = "Standard_DS2_v2"
  security_type = "Standard"  # Usa "TrustedLaunch" si tu imagen es Gen2 (sku *-g2)

  marketplace_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"      # o "2019-datacenter-g2" para TrustedLaunch
    version   = "latest"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  data_disks = [
    { lun = 0, size_gb = 40 }  # caching=ReadOnly y StandardSSD_LRS por default
  ]

  # IP dinámica (default)
  # private_ip_allocation = "Dynamic"

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Equipo Infra"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = { azurerm = azurerm.xpe_shared_poc }
}

2) Windows con IP estática

module "virtual_machine_web" {
  source              = "./modules/virtual_machine_marketplace"
  vm_name             = "vm-web-02"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "windows"
  vm_size       = "Standard_DS2_v2"
  security_type = "Standard"

  marketplace_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  private_ip_allocation = "Static"
  private_ip_address    = "10.10.2.25"   # Debe estar libre y dentro del rango de la subnet

  admin_username = var.admin_username
  admin_password = var.admin_password

  data_disks = [{ lun = 0, size_gb = 40 }]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Equipo Infra"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = { azurerm = azurerm.xpe_shared_poc }
}

3) Linux desde Marketplace (Ubuntu Gen2 con Trusted Launch)

module "virtual_machine_app" {
  source              = "./modules/virtual_machine_marketplace"
  vm_name             = "vm-app-01"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "linux"
  vm_size       = "Standard_DS2_v2"
  security_type = "TrustedLaunch"

  marketplace_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"  # Gen2 compatible con Trusted Launch
    version   = "latest"
  }

  admin_username = "spyderadmin"
  admin_password = var.admin_password

  data_disks = [
    { lun = 0, size_gb = 128, caching = "ReadWrite", storage_account_type = "Premium_LRS" }
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

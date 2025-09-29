locals {
  is_trusted_launch       = lower(var.security_type) == "trustedlaunch"
  os_disk_caching_default = coalesce(var.os_disk_caching, "ReadWrite")

  # Mapear data_disks por LUN para crear y adjuntar discos gestionados
  data_disks_by_lun = { for d in var.data_disks : d.lun => d }

  # Normalizar asignación de IP privada
  ip_alloc = lower(var.private_ip_allocation) == "static" ? "Static" : "Dynamic"
}

# NIC (sin IP pública, sin NSG en la NIC)
resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_version    = var.private_ip_version
    private_ip_address_allocation = local.ip_alloc
    private_ip_address            = local.ip_alloc == "Static" ? var.private_ip_address : null
  }

  tags = var.tags
}

# ===================== LINUX =====================
resource "azurerm_linux_virtual_machine" "this" {
  count                           = lower(var.os_type) == "linux" ? 1 : 0
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.this.id]
  zone                            = var.zone

  # Imagen de Marketplace
  source_image_reference {
    publisher = var.marketplace_image.publisher
    offer     = var.marketplace_image.offer
    sku       = var.marketplace_image.sku
    version   = var.marketplace_image.version
  }

  # Seguridad
  
  vtpm_enabled        = local.is_trusted_launch
  secure_boot_enabled = local.is_trusted_launch

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = local.os_disk_caching_default
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  # Boot diagnostics (opcional)
  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_uri == null ? [] : [1]
    content { storage_account_uri = var.boot_diagnostics_storage_uri }
  }

  tags = var.tags
}

# ===================== WINDOWS =====================
resource "azurerm_windows_virtual_machine" "this" {
  count                 = lower(var.os_type) == "windows" ? 1 : 0
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  provision_vm_agent    = true
  network_interface_ids = [azurerm_network_interface.this.id]
  zone                  = var.zone

  # Imagen de Marketplace
  source_image_reference {
    publisher = var.marketplace_image.publisher
    offer     = var.marketplace_image.offer
    sku       = var.marketplace_image.sku
    version   = var.marketplace_image.version
  }


  vtpm_enabled        = local.is_trusted_launch
  secure_boot_enabled = local.is_trusted_launch

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = local.os_disk_caching_default
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_uri == null ? [] : [1]
    content { storage_account_uri = var.boot_diagnostics_storage_uri }
  }

  tags = var.tags
}

# ===================== DATA DISKS =====================

# Crear Managed Disks vacíos
resource "azurerm_managed_disk" "data" {
  for_each            = local.data_disks_by_lun
  name                = "${var.vm_name}-datadisk-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = coalesce(try(each.value.storage_account_type, null), "StandardSSD_LRS")
  create_option        = "Empty"
  disk_size_gb         = each.value.size_gb

  tags = var.tags
}

# Adjuntar a VM Linux
resource "azurerm_virtual_machine_data_disk_attachment" "linux" {
  for_each           = lower(var.os_type) == "linux" ? azurerm_managed_disk.data : {}
  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_linux_virtual_machine.this[0].id
  lun                = each.key
  caching            = coalesce(try(local.data_disks_by_lun[each.key].caching, null), "ReadOnly")
}

# Adjuntar a VM Windows
resource "azurerm_virtual_machine_data_disk_attachment" "windows" {
  for_each           = lower(var.os_type) == "windows" ? azurerm_managed_disk.data : {}
  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_windows_virtual_machine.this[0].id
  lun                = each.key
  caching            = coalesce(try(local.data_disks_by_lun[each.key].caching, null), "ReadOnly")
}

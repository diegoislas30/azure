# modules/virtual_machine/main.tf
locals {
  is_trusted_launch        = lower(var.security_type) == "trustedlaunch"
  os_disk_caching_default  = var.os_disk_caching != null ? var.os_disk_caching : "ReadWrite"
}

resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = tomap(variable.tags)
}

resource "azurerm_linux_virtual_machine" "this" {
  count                              = var.os_type == "linux" ? 1 : 0
  name                               = var.vm_name
  resource_group_name                = var.resource_group_name
  location                           = var.location
  size                               = var.vm_size
  admin_username                     = var.admin_username
  admin_password                     = var.admin_password
  disable_password_authentication    = false
  network_interface_ids              = [azurerm_network_interface.this.id]
  zone                               = var.zone
  source_image_id                    = var.source_image_id
  vtpm_enabled                       = local.is_trusted_launch
  secure_boot_enabled                = local.is_trusted_launch

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = local.os_disk_caching_default
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      name                 = "${var.vm_name}-datadisk-${data_disk.value.lun}"
      lun                  = data_disk.value.lun
      disk_size_gb         = data_disk.value.size_gb
      caching              = coalesce(try(data_disk.value.caching, null), "ReadOnly")
      storage_account_type = coalesce(try(data_disk.value.storage_account_type, null), "StandardSSD_LRS")
    }
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  tags = tomap(variable.tags)
}

resource "azurerm_windows_virtual_machine" "this" {
  count                 = var.os_type == "windows" ? 1 : 0
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  provision_vm_agent    = true
  network_interface_ids = [azurerm_network_interface.this.id]
  zone                  = var.zone
  source_image_id       = var.source_image_id
  vtpm_enabled          = local.is_trusted_launch
  secure_boot_enabled   = local.is_trusted_launch

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = local.os_disk_caching_default
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      name                 = "${var.vm_name}-datadisk-${data_disk.value.lun}"
      lun                  = data_disk.value.lun
      disk_size_gb         = data_disk.value.size_gb
      caching              = coalesce(try(data_disk.value.caching, null), "ReadOnly")
      storage_account_type = coalesce(try(data_disk.value.storage_account_type, null), "StandardSSD_LRS")
    }
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  tags = var.tags
}

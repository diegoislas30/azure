locals {
  effective_private_ip_allocation = var.private_ip_address != null ? "Static" : var.private_ip_address_allocation
}

resource "azurerm_public_ip" "this" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  domain_name_label   = var.public_ip_domain_name_label

  tags = tomap(var.tags)
}

resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = local.effective_private_ip_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.this[0].id : null
  }

  tags = tomap(var.tags)
}

resource "azurerm_network_interface_security_group_association" "this" {
  count = var.network_security_group_id != null ? 1 : 0

  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "this" {
  count = lower(var.os_type) == "linux" ? 1 : 0

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.this.id]

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_id = var.source_image_id

  secure_boot_enabled = true
  vtpm_enabled        = true

  tags = tomap(var.tags)

  lifecycle {
    precondition {
      condition     = var.admin_password != null && trim(var.admin_password) != ""
      error_message = "Debes proporcionar admin_password para las máquinas Linux."
    }
    precondition {
      condition     = var.source_image_id != null && trim(var.source_image_id) != ""
      error_message = "Debes proporcionar source_image_id con la ruta de Azure Compute Gallery."
    }
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  count = lower(var.os_type) == "windows" ? 1 : 0

  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  admin_username     = var.admin_username
  admin_password     = var.admin_password
  network_interface_ids = [azurerm_network_interface.this.id]

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_id = var.source_image_id

  secure_boot_enabled = true
  vtpm_enabled        = true
  

  tags = tomap(var.tags)

  lifecycle {
    precondition {
      condition     = var.admin_password != null && trim(var.admin_password) != ""
      error_message = "Debes proporcionar admin_password para las máquinas Windows."
    }
    precondition {
      condition     = var.source_image_id != null && trim(var.source_image_id) != ""
      error_message = "Debes proporcionar source_image_id con la ruta de Azure Compute Gallery."
    }
  }
}

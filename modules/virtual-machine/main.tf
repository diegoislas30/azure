resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    # Sin IP pública
  }

  tags = var.tags
}

# NSG interno opcional
resource "azurerm_network_security_group" "this" {
  count               = var.create_builtin_nsg && var.nsg_id == null ? 1 : 0
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Regla opcional para RDP desde un CIDR
  dynamic "security_rule" {
    for_each = var.allow_rdp_from_cidr == null ? [] : [var.allow_rdp_from_cidr]
    content {
      name                       = "allow-rdp-from-cidr"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = security_rule.value
      destination_address_prefix = "*"
    }
  }

  # Denegar todo lo demás inbound
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Asociación de NSG interno
resource "azurerm_network_interface_security_group_association" "assoc_builtin" {
  count                     = var.create_builtin_nsg && var.nsg_id == null ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

# Asociación de NSG externo
resource "azurerm_network_interface_security_group_association" "assoc_external" {
  count                     = var.nsg_id != null ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.this.id]

  # Imagen Windows Server 2022 Datacenter
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      lun                  = data_disk.value.lun
      caching              = data_disk.value.caching
      storage_account_type = data_disk.value.storage_type
      disk_size_gb         = data_disk.value.size_gb
    }
  }

  identity {
    type = "SystemAssigned"
  }

  enable_automatic_updates   = true
  patch_mode                 = "AutomaticByOS"
  provision_vm_agent         = true
  allow_extension_operations = true
  secure_boot_enabled        = true
  vtpm_enabled               = true

  tags = var.tags
}

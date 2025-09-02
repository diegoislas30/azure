#############################################
# NIC sin IP pública
#############################################
resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    # Sin IP pública (no public_ip_address_id)
  }

  tags = var.tags
}

#############################################
# NSG interno opcional (si no pasas nsg_id)
#############################################
resource "azurerm_network_security_group" "this" {
  count               = var.create_builtin_nsg && var.nsg_id == null ? 1 : 0
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Regla opcional de RDP desde un CIDR controlado
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

  # Denegar todo el resto de inbound
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

# Asociar NSG interno a la NIC
resource "azurerm_network_interface_security_group_association" "assoc_builtin" {
  count                     = var.create_builtin_nsg && var.nsg_id == null ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

# Asociar NSG externo a la NIC (si se pasa nsg_id)
resource "azurerm_network_interface_security_group_association" "assoc_external" {
  count                     = var.nsg_id != null ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.nsg_id
}

#############################################
# VM Windows
#############################################
resource "azurerm_windows_virtual_machine" "this" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.this.id]

  # Imagen: Windows Server 2022 Datacenter
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  # Disco del SO
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  # Identidad administrada (para Key Vault, etc.)
  identity {
    type = "SystemAssigned"
  }

  # Buenas prácticas
  enable_automatic_updates   = true
  patch_mode                 = "AutomaticByOS"
  provision_vm_agent         = true
  allow_extension_operations = true
  secure_boot_enabled        = true
  vtpm_enabled               = true

  tags = var.tags
}

#############################################
# Data Disks (Managed Disks + Attachment)
#############################################

# Crear managed disks a partir de la lista data_disks (clave = LUN)
resource "azurerm_managed_disk" "data" {
  for_each            = { for d in var.data_disks : d.lun => d }
  name                = "${var.vm_name}-datadisk-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = each.value.storage_type
  create_option        = "Empty"
  disk_size_gb         = each.value.size_gb

  tags = var.tags
}

# Adjuntar cada disco a la VM
resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each           = { for d in var.data_disks : d.lun => d }
  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.this.id
  lun                = each.value.lun
  caching            = each.value.caching
}

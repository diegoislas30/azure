# Subred efectiva para Private Endpoints (dedicada o la de MI)
locals {
  pe_subnet_id = coalesce(var.pe_subnet_id, var.subnet_id)
}

# ===========================================
# (Opcional) NSG si no lo gestiona tu módulo
# ===========================================
resource "azurerm_network_security_group" "mi" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.name}-mi-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Inbound recomendado para operación de MI
  security_rule {
    name                       = "Allow_SQLManagement_Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "SqlManagement"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_VirtualNetwork_Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Outbound a servicios de plataforma
  security_rule {
    name                       = "Allow_Storage_Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "Allow_AzureMonitor_Outbound"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureMonitor"
  }

  security_rule {
    name                       = "Allow_KeyVault_Outbound"
    priority                   = 220
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureKeyVault"
  }
}

resource "azurerm_subnet_network_security_group_association" "mi" {
  count = var.create_nsg && var.associate_nsg_to_subnet ? 1 : 0

  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.mi[0].id
}

# ===========================================
# Azure SQL Managed Instance
# ===========================================
resource "azurerm_mssql_managed_instance" "this" {
  name                           = var.name
  resource_group_name            = var.resource_group_name
  location                       = var.location

  administrator_login            = var.admin_login
  administrator_login_password   = var.admin_password

  license_type                   = var.license_type
  sku_name                       = var.sku_name
  vcores                         = var.vcores
  storage_size_in_gb             = var.storage_size_gb

  subnet_id                      = var.subnet_id
  timezone_id                    = var.timezone_id
  collation                      = var.collation
  minimum_tls_version            = var.minimum_tls_version
  public_data_endpoint_enabled   = var.public_data_endpoint_enabled
  maintenance_configuration_name = var.maintenance_configuration_name

  tags = var.tags
}

# ===========================================
# Seguridad: Alertas (Defender/ATP)
# ===========================================
resource "azurerm_mssql_managed_instance_security_alert_policy" "this" {
  managed_instance_name       = azurerm_mssql_managed_instance.this.name
  resource_group_name         = azurerm_mssql_managed_instance.this.resource_group_name
  state                       = var.security_alerts_state
  email_account_admins        = var.security_alerts_email_admins
  email_addresses             = var.security_alerts_emails
  retention_days              = var.security_alerts_retention_days
  storage_endpoint            = var.security_alerts_storage_endpoint
  storage_account_access_key  = var.security_alerts_storage_key
}

# ===========================================
# Auditoría extendida (LA / Storage)
# ===========================================
resource "azurerm_log_analytics_workspace" "this" {
  count               = var.create_log_analytics ? 1 : 0
  name                = "${var.name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.law_retention_days
  tags                = var.tags
}

resource "azurerm_mssql_managed_instance_extended_auditing_policy" "this" {
  managed_instance_id        = azurerm_mssql_managed_instance.this.id
  log_analytics_workspace_id = coalesce(
    var.audit_log_analytics_workspace_id,
    var.create_log_analytics ? azurerm_log_analytics_workspace.this[0].id : null
  )
  storage_endpoint           = var.audit_storage_endpoint
  storage_account_access_key = var.audit_storage_key
  retention_in_days          = var.audit_retention_days
}

# ===========================================
# Diagnósticos a Log Analytics
# ===========================================
resource "azurerm_monitor_diagnostic_setting" "mi" {
  count                      = var.enable_diagnostics ? 1 : 0
  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_mssql_managed_instance.this.id
  log_analytics_workspace_id = coalesce(
    var.diagnostics_log_analytics_workspace_id,
    var.create_log_analytics ? azurerm_log_analytics_workspace.this[0].id : null
  )

  dynamic "enabled_log" {
    for_each = var.diagnostic_logs
    content { category = enabled_log.value }
  }

  dynamic "metric" {
    for_each = var.diagnostic_metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
}

# ======================================================
# PRIVATE ENDPOINTS + PRIVATE DNS (genéricos)
# ======================================================

# Nombres de zonas a crear (sin duplicados)
locals {
  dns_zone_names_to_create = distinct(flatten([
    for pe in var.private_endpoints : (
      pe.create_dns_zones ? pe.dns_zone_names : []
    )
  ]))
}

# Crear Private DNS Zones (si aplica)
resource "azurerm_private_dns_zone" "this" {
  for_each            = { for n in local.dns_zone_names_to_create : n => n }
  name                = each.key
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Enlazar DNS Zones a la VNet (usando var.vnet_id)
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each               = azurerm_private_dns_zone.this
  name                   = "link-${replace(each.key, ".", "-")}"
  resource_group_name    = var.resource_group_name
  private_dns_zone_name  = each.value.name
  virtual_network_id     = var.vnet_id
  registration_enabled   = false
}

# Zonas efectivas por PE (creadas o provistas por ID)
locals {
  pe_dns_zone_ids = {
    for pe in var.private_endpoints :
    pe.name => (
      pe.create_dns_zones
      ? [for zn in pe.dns_zone_names : azurerm_private_dns_zone.this[zn].id]
      : pe.dns_zone_ids
    )
  }
}

# Crear Private Endpoints
resource "azurerm_private_endpoint" "pe" {
  for_each            = { for pe in var.private_endpoints : pe.name => pe }

  name                = "${var.name}-${each.value.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = local.pe_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name}-${each.value.name}-psc"
    private_connection_resource_id = each.value.target_resource_id
    is_manual_connection           = false
    subresource_names              = each.value.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = length(lookup(local.pe_dns_zone_ids, each.key, [])) > 0 ? [1] : []
    content {
      name                 = "pdns-${each.value.name}"
      private_dns_zone_ids = lookup(local.pe_dns_zone_ids, each.key, [])
    }
  }
}

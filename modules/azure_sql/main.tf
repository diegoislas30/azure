# ================== Locals ==================
locals {
  # Normalizar valores
  sku_name_normalized = upper(var.sku_name)

  # Configurar firewall rules solo si se permite acceso público
  firewall_rules_effective = var.allow_public_access ? var.firewall_rules : []
}

# ================== Azure SQL Server ==================
resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = var.server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  minimum_tls_version               = var.minimum_tls_version
  public_network_access_enabled     = var.allow_public_access
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator != null ? [var.azuread_administrator] : []
    content {
      login_username = azuread_administrator.value.login_username
      object_id      = azuread_administrator.value.object_id
      tenant_id      = azuread_administrator.value.tenant_id
    }
  }

  dynamic "identity" {
    for_each = var.enable_system_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  tags = tomap(var.tags)
}

# ================== Azure SQL Database ==================
resource "azurerm_mssql_database" "this" {
  for_each = { for db in var.databases : db.name => db }

  name                        = each.value.name
  server_id                   = azurerm_mssql_server.this.id
  collation                   = lookup(each.value, "collation", var.default_collation)
  max_size_gb                 = lookup(each.value, "max_size_gb", null)
  sku_name                    = lookup(each.value, "sku_name", var.sku_name)
  zone_redundant              = lookup(each.value, "zone_redundant", var.zone_redundant)
  read_scale                  = lookup(each.value, "read_scale", false)
  auto_pause_delay_in_minutes = lookup(each.value, "auto_pause_delay_in_minutes", null)
  min_capacity                = lookup(each.value, "min_capacity", null)

  dynamic "short_term_retention_policy" {
    for_each = lookup(each.value, "short_term_retention_days", null) != null ? [1] : []
    content {
      retention_days = lookup(each.value, "short_term_retention_days", 7)
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = lookup(each.value, "long_term_retention", null) != null ? [each.value.long_term_retention] : []
    content {
      weekly_retention  = lookup(long_term_retention_policy.value, "weekly_retention", null)
      monthly_retention = lookup(long_term_retention_policy.value, "monthly_retention", null)
      yearly_retention  = lookup(long_term_retention_policy.value, "yearly_retention", null)
      week_of_year      = lookup(long_term_retention_policy.value, "week_of_year", null)
    }
  }

  tags = tomap(var.tags)
}

# ================== Firewall Rules ==================
resource "azurerm_mssql_firewall_rule" "this" {
  for_each = { for rule in local.firewall_rules_effective : rule.name => rule }

  name             = each.value.name
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

# ================== Virtual Network Rules ==================
resource "azurerm_mssql_virtual_network_rule" "this" {
  for_each = { for rule in var.vnet_rules : rule.name => rule }

  name      = each.value.name
  server_id = azurerm_mssql_server.this.id
  subnet_id = each.value.subnet_id
}

# ================== Private Endpoint (opcional) ==================
resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint_enabled ? 1 : 0

  name                = "${var.server_name}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.server_name}-psc"
    private_connection_resource_id = azurerm_mssql_server.this.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_endpoint_private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "default"
      private_dns_zone_ids = var.private_endpoint_private_dns_zone_ids
    }
  }

  tags = tomap(var.tags)
}

# ================== Transparent Data Encryption ==================
resource "azurerm_mssql_server_transparent_data_encryption" "this" {
  count = var.enable_tde ? 1 : 0

  server_id        = azurerm_mssql_server.this.id
  key_vault_key_id = var.tde_key_vault_key_id
}

# ================== Extended Auditing Policy ==================
resource "azurerm_mssql_server_extended_auditing_policy" "this" {
  count = var.enable_auditing ? 1 : 0

  server_id                               = azurerm_mssql_server.this.id
  storage_endpoint                        = var.audit_storage_endpoint
  storage_account_access_key              = var.audit_storage_account_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.audit_retention_days
  log_monitoring_enabled                  = var.audit_log_monitoring_enabled
}

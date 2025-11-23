# ================== Data sources ==================
data "azurerm_client_config" "current" {}

# ================== Key Vault ==================
resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  public_network_access_enabled   = var.public_network_access_enabled

  # Network ACLs
  dynamic "network_acls" {
    for_each = var.enable_network_acls ? [1] : []
    content {
      bypass                     = var.network_acls_bypass
      default_action             = var.network_acls_default_action
      ip_rules                   = var.network_acls_ip_rules
      virtual_network_subnet_ids = var.network_acls_subnet_ids
    }
  }

  tags = var.tags
}

# ================== Private Endpoint ==================
resource "azurerm_private_endpoint" "this" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_endpoint_private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "${var.name}-dns-zone-group"
      private_dns_zone_ids = var.private_endpoint_private_dns_zone_ids
    }
  }

  tags = var.tags
}

# ================== Access Policies (opcional, si RBAC no está habilitado) ==================
resource "azurerm_key_vault_access_policy" "this" {
  for_each = var.enable_rbac_authorization ? {} : var.access_policies

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.object_id

  # Permisos de claves
  key_permissions = lookup(each.value, "key_permissions", [])

  # Permisos de secretos
  secret_permissions = lookup(each.value, "secret_permissions", [])

  # Permisos de certificados
  certificate_permissions = lookup(each.value, "certificate_permissions", [])

  # Permisos de storage
  storage_permissions = lookup(each.value, "storage_permissions", [])
}

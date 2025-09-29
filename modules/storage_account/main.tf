# --------- Derivaciones sin ternarias multilínea ---------
locals {
  storage_type_norm = lower(var.storage_type)     # "blob" | "file"
  performance_norm  = lower(var.performance)      # "standard" | "premium"

  # account_kind por performance + tipo:
  # premium+file -> FileStorage | premium+blob -> BlockBlobStorage
  # standard     -> StorageV2
  account_kind_map = {
    premium = {
      file = "FileStorage"
      blob = "BlockBlobStorage"
    }
    standard = {
      file = "StorageV2"
      blob = "StorageV2"
    }
  }

  account_kind = local.account_kind_map[local.performance_norm][local.storage_type_norm]

  # SKU: Standard_LRS, Premium_ZRS, etc.
  skuname = "${var.performance}_${replace(upper(var.redundancy), "-", "_")}"

  # Reglas de red sólo si es privado
  network_rules_effective = var.allow_public_network ? null : {
    bypass     = var.network_bypass
    ip_rules   = var.allowed_ip_rules
    subnet_ids = var.allowed_subnet_ids
  }

  # Flag para decidir qué módulo instanciar
  is_v2 = local.account_kind == "StorageV2"
}

# ========= StorageV2 (sí usa access_tier) =========
module "sa_v2" {
  count   = local.is_v2 ? 1 : 0
  source  = "getindata/storage-account/azurerm"
  version = "1.7.1"

  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name

  account_kind    = "StorageV2"
  skuname         = local.skuname
  min_tls_version = var.min_tls_version
  access_tier     = var.access_tier              # Hot | Cool (válido aquí)

  network_rules = local.network_rules_effective

  private_endpoint_enabled              = var.private_endpoint_enabled
  private_endpoint_subresource_name     = var.private_endpoint_subresource_name
  private_endpoint_subnet_id            = var.private_endpoint_subnet_id
  private_endpoint_private_dns_zone_ids = var.private_endpoint_private_dns_zone_ids

  tags = tomap(var.tags)
}

# ========= FileStorage / BlockBlobStorage (NO usa access_tier) =========
module "sa_nonv2" {
  count   = local.is_v2 ? 0 : 1
  source  = "getindata/storage-account/azurerm"
  version = "1.7.1"

  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name

  account_kind    = local.account_kind          # FileStorage | BlockBlobStorage
  skuname         = local.skuname
  min_tls_version = var.min_tls_version
  # OJO: NO pasar access_tier aquí

  network_rules = local.network_rules_effective

  private_endpoint_enabled              = var.private_endpoint_enabled
  private_endpoint_subresource_name     = var.private_endpoint_subresource_name
  private_endpoint_subnet_id            = var.private_endpoint_subnet_id
  private_endpoint_private_dns_zone_ids = var.private_endpoint_private_dns_zone_ids

  tags = tomap(var.tags)
}

# Módulo de Azure Key Vault con Private Endpoint

Este módulo de Terraform crea un Azure Key Vault con soporte completo para Private Endpoints, Network ACLs y configuración de seguridad avanzada.

## Características

- ✅ Azure Key Vault con SKU standard o premium
- ✅ Private Endpoint con integración de Private DNS Zone
- ✅ Network ACLs configurables
- ✅ Soporte para RBAC o Access Policies
- ✅ Soft delete y purge protection
- ✅ Configuración de acceso público/privado

## Uso

### Ejemplo Básico con Private Endpoint

```hcl
module "key_vault" {
  source = "./modules/key_vault"

  name                = "mykv-prod-001"
  location            = "eastus"
  rg_name             = "rg-keyvault-prod"
  sku_name            = "standard"

  # Seguridad
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90

  # Network ACLs
  enable_network_acls           = true
  network_acls_default_action   = "Deny"
  network_acls_bypass           = "AzureServices"
  network_acls_ip_rules         = ["203.0.113.0/24"]
  network_acls_subnet_ids       = [azurerm_subnet.example.id]

  # Private Endpoint
  private_endpoint_enabled              = true
  private_endpoint_subnet_id            = azurerm_subnet.pe_subnet.id
  private_endpoint_private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]

  tags = {
    UDN      = "12345"
    OWNER    = "team@example.com"
    xpeowner = "john.doe"
    proyecto = "infrastructure"
    ambiente = "production"
  }
}
```

### Ejemplo con Access Policies (sin RBAC)

```hcl
module "key_vault" {
  source = "./modules/key_vault"

  name                = "mykv-dev-001"
  location            = "eastus"
  rg_name             = "rg-keyvault-dev"

  # Deshabilitar RBAC para usar Access Policies
  enable_rbac_authorization = false

  # Access Policies
  access_policies = {
    admin = {
      object_id = "00000000-0000-0000-0000-000000000000"
      key_permissions = [
        "Get", "List", "Create", "Delete", "Update"
      ]
      secret_permissions = [
        "Get", "List", "Set", "Delete"
      ]
      certificate_permissions = [
        "Get", "List", "Create", "Delete"
      ]
    }
  }

  # Private Endpoint
  private_endpoint_enabled   = true
  private_endpoint_subnet_id = azurerm_subnet.pe_subnet.id

  tags = {
    UDN      = "12345"
    OWNER    = "team@example.com"
    xpeowner = "john.doe"
    proyecto = "infrastructure"
    ambiente = "development"
  }
}
```

### Ejemplo Mínimo (sin Private Endpoint)

```hcl
module "key_vault" {
  source = "./modules/key_vault"

  name     = "mykv-test-001"
  location = "eastus"
  rg_name  = "rg-keyvault-test"

  private_endpoint_enabled = false

  tags = {
    UDN      = "12345"
    OWNER    = "team@example.com"
    xpeowner = "john.doe"
    proyecto = "testing"
    ambiente = "test"
  }
}
```

## Variables

### Requeridas

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `name` | string | Nombre del Key Vault (3-24 caracteres) |
| `location` | string | Región de Azure |
| `rg_name` | string | Nombre del Resource Group |
| `tags` | object | Tags obligatorios (UDN, OWNER, xpeowner, proyecto, ambiente) |

### Opcionales - Key Vault

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `sku_name` | string | `"standard"` | SKU del Key Vault (standard o premium) |
| `enabled_for_deployment` | bool | `false` | Permitir VMs recuperar certificados |
| `enabled_for_disk_encryption` | bool | `false` | Permitir Azure Disk Encryption |
| `enabled_for_template_deployment` | bool | `false` | Permitir ARM templates |
| `enable_rbac_authorization` | bool | `true` | Usar RBAC en vez de Access Policies |
| `purge_protection_enabled` | bool | `true` | Protección contra purga |
| `soft_delete_retention_days` | number | `90` | Días de retención (7-90) |
| `public_network_access_enabled` | bool | `false` | Acceso público habilitado |

### Opcionales - Network ACLs

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `enable_network_acls` | bool | `true` | Habilitar reglas de red |
| `network_acls_bypass` | string | `"AzureServices"` | Bypass (AzureServices o None) |
| `network_acls_default_action` | string | `"Deny"` | Acción por defecto (Allow o Deny) |
| `network_acls_ip_rules` | list(string) | `[]` | IPs permitidas (CIDR) |
| `network_acls_subnet_ids` | list(string) | `[]` | IDs de subnets permitidas |

### Opcionales - Private Endpoint

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `private_endpoint_enabled` | bool | `false` | Crear Private Endpoint |
| `private_endpoint_subnet_id` | string | `null` | ID de subnet para PE |
| `private_endpoint_private_dns_zone_ids` | list(string) | `[]` | IDs de Private DNS Zones |

### Opcionales - Access Policies

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `access_policies` | map(object) | `{}` | Access policies (solo si RBAC deshabilitado) |

## Outputs

| Output | Descripción |
|--------|-------------|
| `key_vault_id` | ID del Key Vault |
| `key_vault_name` | Nombre del Key Vault |
| `key_vault_uri` | URI del Key Vault |
| `key_vault_tenant_id` | Tenant ID del Key Vault |
| `private_endpoint_id` | ID del Private Endpoint |
| `private_endpoint_name` | Nombre del Private Endpoint |
| `private_endpoint_private_ip` | IP privada del Private Endpoint |
| `private_endpoint_network_interface_id` | ID de la interfaz de red del PE |

## Requisitos

- Terraform >= 1.0
- Provider azurerm ~> 4.0

## Notas

- El nombre del Key Vault debe ser globalmente único en Azure
- Si usas Private Endpoint, debes configurar una Private DNS Zone para `privatelink.vaultcore.azure.net`
- Con RBAC habilitado (`enable_rbac_authorization = true`), las access policies se ignoran
- El soft delete está habilitado por defecto con 90 días de retención
- La purge protection está habilitada por defecto para seguridad adicional

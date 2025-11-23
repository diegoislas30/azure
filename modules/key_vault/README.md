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

### Ejemplo Completo con VNet y Private Endpoint

```hcl
# Crear Resource Group
module "rg" {
  source              = "./modules/resource_group"
  resource_group_name = "rg-keyvault-prod"
  location            = "eastus"

  tags = {
    UDN      = "12345"
    OWNER    = "team@example.com"
    xpeowner = "john.doe"
    proyecto = "infrastructure"
    ambiente = "production"
  }
}

# Crear VNet con subnets
module "vnet" {
  source              = "./modules/vnets"
  vnet_name           = "vnet-keyvault-prod"
  location            = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnets = [
    {
      name           = "snet-private-endpoints"
      address_prefix = "10.0.1.0/24"
    },
    {
      name           = "snet-app"
      address_prefix = "10.0.2.0/24"
    }
  ]

  tags = {
    UDN      = "12345"
    OWNER    = "team@example.com"
    xpeowner = "john.doe"
    proyecto = "infrastructure"
    ambiente = "production"
  }
}

# Crear Private DNS Zone para Key Vault
resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "vnet-link-keyvault"
  resource_group_name   = module.rg.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = module.vnet.vnet_id
}

# Crear Key Vault con Private Endpoint
module "key_vault" {
  source = "./modules/key_vault"

  name     = "mykv-prod-001"
  location = module.rg.resource_group_location
  rg_name  = module.rg.resource_group_name
  sku_name = "standard"

  # Seguridad
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90

  # Network ACLs - Usar outputs del módulo vnets
  enable_network_acls         = true
  network_acls_default_action = "Deny"
  network_acls_bypass         = "AzureServices"
  network_acls_ip_rules       = ["203.0.113.0/24"]
  vnet_subnet_ids             = module.vnet.subnet_ids
  network_acls_subnet_names   = ["snet-app"]

  # Private Endpoint - Usar outputs del módulo vnets
  private_endpoint_enabled              = true
  vnet_subnet_ids                       = module.vnet.subnet_ids
  private_endpoint_subnet_name          = "snet-private-endpoints"
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
# Módulo VNet ya creado
module "vnet_dev" {
  source              = "./modules/vnets"
  vnet_name           = "vnet-keyvault-dev"
  location            = "eastus"
  resource_group_name = "rg-keyvault-dev"
  address_space       = ["10.1.0.0/16"]

  subnets = [
    {
      name           = "snet-pe"
      address_prefix = "10.1.1.0/24"
    }
  ]

  tags = {
    UDN      = "12345"
    OWNER    = "team@example.com"
    xpeowner = "john.doe"
    proyecto = "infrastructure"
    ambiente = "development"
  }
}

module "key_vault" {
  source = "./modules/key_vault"

  name     = "mykv-dev-001"
  location = "eastus"
  rg_name  = "rg-keyvault-dev"

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

  # Private Endpoint - Usar outputs del módulo vnets
  private_endpoint_enabled              = true
  vnet_subnet_ids                       = module.vnet_dev.subnet_ids
  private_endpoint_subnet_name          = "snet-pe"
  private_endpoint_private_dns_zone_ids = []

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
| `vnet_subnet_ids` | map(string) | `{}` | Map de subnet IDs del módulo vnets |
| `network_acls_subnet_names` | list(string) | `[]` | Nombres de subnets permitidas |

### Opcionales - Private Endpoint

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `private_endpoint_enabled` | bool | `false` | Crear Private Endpoint |
| `private_endpoint_subnet_name` | string | `null` | Nombre de subnet para PE |
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

## Notas Importantes

### Integración con el módulo vnets
- **IMPORTANTE**: El módulo Key Vault requiere el output `subnet_ids` del módulo vnets
- Debes pasar `module.vnet.subnet_ids` al parámetro `vnet_subnet_ids`
- Las subnets se referencian por nombre, no por ID directo
- Ejemplo: `private_endpoint_subnet_name = "snet-pe"` buscará el ID en `vnet_subnet_ids["snet-pe"]`

### Configuración General
- El nombre del Key Vault debe ser globalmente único en Azure (3-24 caracteres alfanuméricos y guiones)
- Si usas Private Endpoint, debes configurar una Private DNS Zone para `privatelink.vaultcore.azure.net`
- Con RBAC habilitado (`enable_rbac_authorization = true`), las access policies se ignoran
- El soft delete está habilitado por defecto con 90 días de retención
- La purge protection está habilitada por defecto para seguridad adicional

### Network ACLs
- Para permitir subnets en Network ACLs, usa `network_acls_subnet_names` con los nombres de las subnets
- El módulo convertirá automáticamente los nombres a IDs usando `vnet_subnet_ids`

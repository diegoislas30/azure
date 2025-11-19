# Módulo Azure SQL

Este módulo de Terraform permite desplegar Azure SQL Server y bases de datos SQL con configuraciones avanzadas de seguridad y red.

## Características

- ✅ Azure SQL Server con versiones 12.0 y 15.0
- ✅ Múltiples bases de datos SQL con configuraciones individuales
- ✅ Administrador de Azure AD (opcional)
- ✅ Reglas de firewall personalizables
- ✅ Reglas de Virtual Network
- ✅ Private Endpoint (opcional)
- ✅ Transparent Data Encryption (TDE) con Key Vault
- ✅ Auditoría extendida con Storage Account
- ✅ System Assigned Identity
- ✅ Configuración de retención (short-term y long-term)
- ✅ Zone redundancy y read scale

## SKUs Disponibles

### Básico/Estándar
- `Basic` - 5 DTU
- `S0` - 10 DTU
- `S1` - 20 DTU
- `S2` - 50 DTU

### Premium
- `P1` - 125 DTU
- `P2` - 250 DTU
- `P4` - 500 DTU

### vCore (General Purpose)
- `GP_Gen5_2` - 2 vCores
- `GP_Gen5_4` - 4 vCores
- `GP_S_Gen5_2` - Serverless 2 vCores

### vCore (Business Critical)
- `BC_Gen5_2` - 2 vCores
- `BC_Gen5_4` - 4 vCores

## Uso Básico

```hcl
module "sql_server_prod" {
  source = "./modules/azure_sql"

  rg_name  = "rg-database-prod"
  location = "southcentralus"

  server_name                  = "xpe-sqlserver-prod"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password

  databases = [
    {
      name        = "app-db-prod"
      sku_name    = "S1"
      max_size_gb = 250
    }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "ICM"
    ambiente = "prod"
  }

  providers = {
    azurerm = azurerm.Xpertal_XCS
  }
}
```

## Uso con Private Endpoint

```hcl
module "sql_server_private" {
  source = "./modules/azure_sql"

  rg_name  = "rg-database-prod"
  location = "southcentralus"

  server_name                  = "xpe-sqlserver-prod"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  allow_public_access          = false

  databases = [
    {
      name                      = "app-db-prod"
      sku_name                  = "GP_Gen5_2"
      max_size_gb               = 500
      zone_redundant            = true
      short_term_retention_days = 14
    }
  ]

  # Private Endpoint
  private_endpoint_enabled              = true
  private_endpoint_subnet_id            = var.subnet_id
  private_endpoint_private_dns_zone_ids = [var.private_dns_zone_id]

  # Virtual Network Rules
  vnet_rules = [
    {
      name      = "allow-app-subnet"
      subnet_id = var.app_subnet_id
    }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "ICM"
    ambiente = "prod"
  }
}
```

## Uso con Azure AD y Auditoría

```hcl
module "sql_server_secure" {
  source = "./modules/azure_sql"

  rg_name  = "rg-database-prod"
  location = "southcentralus"

  server_name                  = "xpe-sqlserver-prod"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  enable_system_identity       = true

  # Azure AD Administrator
  azuread_administrator = {
    login_username = "admin@xpertal.com"
    object_id      = "12345678-1234-1234-1234-123456789012"
    tenant_id      = "87654321-4321-4321-4321-210987654321"
  }

  databases = [
    {
      name     = "app-db-prod"
      sku_name = "BC_Gen5_4"
      long_term_retention = {
        weekly_retention  = "P1W"
        monthly_retention = "P1M"
        yearly_retention  = "P5Y"
        week_of_year      = 1
      }
    }
  ]

  # Transparent Data Encryption
  enable_tde            = true
  tde_key_vault_key_id  = var.key_vault_key_id

  # Auditing
  enable_auditing                    = true
  audit_storage_endpoint             = var.audit_storage_endpoint
  audit_storage_account_access_key   = var.audit_storage_key
  audit_retention_days               = 90

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "ICM"
    ambiente = "prod"
  }
}
```

## Uso con Firewall Rules (Acceso Público)

```hcl
module "sql_server_public" {
  source = "./modules/azure_sql"

  rg_name  = "rg-database-dev"
  location = "southcentralus"

  server_name                  = "xpe-sqlserver-dev"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  allow_public_access          = true

  databases = [
    {
      name     = "app-db-dev"
      sku_name = "Basic"
    }
  ]

  firewall_rules = [
    {
      name             = "allow-azure-services"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
    {
      name             = "allow-office-ip"
      start_ip_address = "203.0.113.0"
      end_ip_address   = "203.0.113.255"
    }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "diegoenrique.islas@xpertal.com"
    proyecto = "ICM"
    ambiente = "dev"
  }
}
```

## Inputs

| Nombre | Descripción | Tipo | Default | Requerido |
|--------|-------------|------|---------|-----------|
| rg_name | Nombre del Resource Group | string | - | Sí |
| location | Región de Azure | string | - | Sí |
| server_name | Nombre del SQL Server | string | - | Sí |
| administrator_login | Usuario administrador | string | - | Sí |
| administrator_login_password | Contraseña del admin | string | - | Sí |
| databases | Lista de bases de datos | list(object) | [] | No |
| sku_name | SKU por defecto | string | "Basic" | No |
| allow_public_access | Acceso público | bool | false | No |
| private_endpoint_enabled | Habilitar Private Endpoint | bool | false | No |
| enable_tde | Habilitar TDE | bool | false | No |
| enable_auditing | Habilitar auditoría | bool | false | No |

## Outputs

| Nombre | Descripción |
|--------|-------------|
| sql_server_id | ID del SQL Server |
| sql_server_name | Nombre del SQL Server |
| sql_server_fqdn | FQDN del SQL Server |
| database_ids | Map de IDs de databases |
| connection_string | Connection string template |
| private_endpoint_ip | IP del Private Endpoint |

## Notas

- Por defecto, el acceso público está **deshabilitado**
- TLS mínimo recomendado: **1.2**
- Para producción, usar SKUs vCore (GP_Gen5 o BC_Gen5)
- Habilitar auditoría y TDE para cumplimiento
- Usar Private Endpoint para máxima seguridad

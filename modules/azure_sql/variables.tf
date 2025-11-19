# ================== Resource Group / ubicación ==================
variable "rg_name" {
  description = "Nombre del Resource Group."
  type        = string
}

variable "location" {
  description = "Región de Azure (p.ej. eastus, southcentralus)."
  type        = string
}

# ================== SQL Server ==================
variable "server_name" {
  description = "Nombre del Azure SQL Server."
  type        = string
}

variable "server_version" {
  description = "Versión del SQL Server (12.0 = SQL Server 2014, 15.0 = SQL Server 2022)."
  type        = string
  default     = "12.0"
  validation {
    condition     = contains(["12.0", "15.0"], var.server_version)
    error_message = "server_version debe ser 12.0 o 15.0."
  }
}

variable "administrator_login" {
  description = "Usuario administrador del SQL Server."
  type        = string
}

variable "administrator_login_password" {
  description = "Contraseña del administrador del SQL Server."
  type        = string
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "Versión mínima de TLS (1.0, 1.1, 1.2)."
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "minimum_tls_version debe ser 1.0, 1.1 o 1.2."
  }
}

variable "allow_public_access" {
  description = "Permite acceso público al servidor."
  type        = bool
  default     = false
}

variable "outbound_network_restriction_enabled" {
  description = "Habilita restricciones de red saliente."
  type        = bool
  default     = false
}

variable "enable_system_identity" {
  description = "Habilita System Assigned Identity para el SQL Server."
  type        = bool
  default     = false
}

# ================== Azure AD Administrator ==================
variable "azuread_administrator" {
  description = "Configuración del administrador de Azure AD."
  type = object({
    login_username = string
    object_id      = string
    tenant_id      = string
  })
  default = null
}

# ================== Databases ==================
variable "databases" {
  description = "Lista de bases de datos a crear."
  type = list(object({
    name                        = string
    collation                   = optional(string)
    max_size_gb                 = optional(number)
    sku_name                    = optional(string)
    zone_redundant              = optional(bool)
    read_scale                  = optional(bool)
    auto_pause_delay_in_minutes = optional(number)
    min_capacity                = optional(number)
    short_term_retention_days   = optional(number)
    long_term_retention = optional(object({
      weekly_retention  = optional(string)
      monthly_retention = optional(string)
      yearly_retention  = optional(string)
      week_of_year      = optional(number)
    }))
  }))
  default = []
}

variable "default_collation" {
  description = "Collation por defecto para las bases de datos."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sku_name" {
  description = "SKU por defecto para las bases de datos (Basic, S0, S1, P1, GP_S_Gen5_2, etc.)."
  type        = string
  default     = "Basic"
}

variable "zone_redundant" {
  description = "Habilita redundancia de zona por defecto."
  type        = bool
  default     = false
}

# ================== Firewall Rules ==================
variable "firewall_rules" {
  description = "Reglas de firewall para el SQL Server."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

# ================== Virtual Network Rules ==================
variable "vnet_rules" {
  description = "Reglas de red virtual para el SQL Server."
  type = list(object({
    name      = string
    subnet_id = string
  }))
  default = []
}

# ================== Private Endpoint ==================
variable "private_endpoint_enabled" {
  description = "Habilita Private Endpoint para el SQL Server."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "ID de la subnet para el Private Endpoint."
  type        = string
  default     = null
}

variable "private_endpoint_private_dns_zone_ids" {
  description = "IDs de las Private DNS Zones para el Private Endpoint."
  type        = list(string)
  default     = []
}

# ================== Transparent Data Encryption ==================
variable "enable_tde" {
  description = "Habilita Transparent Data Encryption con Key Vault."
  type        = bool
  default     = false
}

variable "tde_key_vault_key_id" {
  description = "ID de la key de Key Vault para TDE."
  type        = string
  default     = null
}

# ================== Auditing ==================
variable "enable_auditing" {
  description = "Habilita auditoría extendida."
  type        = bool
  default     = false
}

variable "audit_storage_endpoint" {
  description = "Endpoint de la cuenta de almacenamiento para auditoría."
  type        = string
  default     = null
}

variable "audit_storage_account_access_key" {
  description = "Access key de la cuenta de almacenamiento para auditoría."
  type        = string
  sensitive   = true
  default     = null
}

variable "audit_retention_days" {
  description = "Días de retención para los logs de auditoría."
  type        = number
  default     = 90
}

variable "audit_log_monitoring_enabled" {
  description = "Habilita monitoreo de logs de auditoría."
  type        = bool
  default     = true
}

# ================== Tags ==================
variable "tags" {
  description = "Tags para los recursos de Azure SQL."
  type = object({
    UDN      = string
    OWNER    = string
    xpeowner = string
    proyecto = string
    ambiente = string
  })
}

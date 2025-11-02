# ==========================
# Identidad y RG
# ==========================
variable "resource_group_name" {
  description = "Nombre del Resource Group donde se despliegan los recursos."
  type        = string
}

variable "location" {
  description = "Región de Azure (por ejemplo, mexico-central)."
  type        = string
}

variable "name" {
  description = "Nombre de la Azure SQL Managed Instance."
  type        = string
}

variable "tags" {
  description = "Mapa de etiquetas a aplicar a todos los recursos."
  type        = map(string)
  default     = {}
}

# ==========================
# Red (IDs ya existentes)
# ==========================
variable "subnet_id" {
  description = "ID de la subred delegada a Microsoft.Sql/managedInstances (para la MI)."
  type        = string
}

variable "vnet_id" {
  description = "ID de la VNet donde se enlazarán las Private DNS Zones."
  type        = string
}

variable "pe_subnet_id" {
  description = "ID de la subred donde crear Private Endpoints. Si es null, usa la subred de la MI."
  type        = string
  default     = null
}

# ==========================
# NSG opcional
# ==========================
variable "create_nsg" {
  description = "Crear un NSG mínimo con service tags si tu módulo de red no lo gestiona."
  type        = bool
  default     = false
}

variable "associate_nsg_to_subnet" {
  description = "Asociar el NSG creado a la subred de la MI (verifica que no exista otro NSG asociado)."
  type        = bool
  default     = false
}

# ==========================
# Azure SQL Managed Instance (cómputo/almacenamiento)
# ==========================
variable "sku_name" {
  description = "SKU de la MI. Ej.: GP_Gen5 (General Purpose) o BC_Gen5 (Business Critical)."
  type        = string
  default     = "GP_Gen5"
}

variable "vcores" {
  description = "Número de vCores asignados a la MI."
  type        = number
  default     = 8
}

variable "storage_size_gb" {
  description = "Tamaño de almacenamiento en GB para la MI."
  type        = number
  default     = 256
}

variable "license_type" {
  description = "Tipo de licencia: BasePrice o LicenseIncluded."
  type        = string
  default     = "BasePrice"
}

variable "admin_login" {
  description = "Usuario administrador de la MI."
  type        = string
}

variable "admin_password" {
  description = "Contraseña del usuario administrador de la MI."
  type        = string
  sensitive   = true
}

variable "timezone_id" {
  description = "Zona horaria del motor SQL (por ejemplo, UTC)."
  type        = string
  default     = "UTC"
}

variable "collation" {
  description = "Collation de la instancia (por ejemplo, SQL_Latin1_General_CP1_CI_AS)."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "minimum_tls_version" {
  description = "Versión mínima de TLS (recomendado 1.2)."
  type        = string
  default     = "1.2"
}

variable "public_data_endpoint_enabled" {
  description = "Habilitar el endpoint público de datos (no recomendado por defecto)."
  type        = bool
  default     = false
}

variable "maintenance_configuration_name" {
  description = "Nombre de la Maintenance Configuration (opcional), p.ej. SQL_Default."
  type        = string
  default     = null
}

# ==========================
# Seguridad: Alertas (Defender/ATP)
# ==========================
variable "security_alerts_state" {
  description = "Estado de las alertas de seguridad (Enabled/Disabled)."
  type        = string
  default     = "Enabled"
}

variable "security_alerts_email_admins" {
  description = "Enviar alertas a los administradores de la suscripción."
  type        = bool
  default     = true
}

variable "security_alerts_emails" {
  description = "Lista de correos adicionales para recibir alertas."
  type        = list(string)
  default     = []
}

variable "security_alerts_retention_days" {
  description = "Días de retención de alertas (para exportación a Storage)."
  type        = number
  default     = 30
}

variable "security_alerts_storage_endpoint" {
  description = "Blob endpoint de Storage para alertas (opcional)."
  type        = string
  default     = null
}

variable "security_alerts_storage_key" {
  description = "Access key del Storage usado para alertas (opcional)."
  type        = string
  sensitive   = true
  default     = null
}

# ==========================
# Auditoría extendida
# ==========================
variable "audit_log_analytics_workspace_id" {
  description = "ID del Log Analytics Workspace externo para auditoría (opcional)."
  type        = string
  default     = null
}

variable "audit_storage_endpoint" {
  description = "Blob endpoint de Storage para auditoría (opcional)."
  type        = string
  default     = null
}

variable "audit_storage_key" {
  description = "Access key del Storage para auditoría (opcional)."
  type        = string
  sensitive   = true
  default     = null
}

variable "audit_retention_days" {
  description = "Días de retención para auditoría extendida."
  type        = number
  default     = 90
}

# ==========================
# Diagnósticos (Azure Monitor)
# ==========================
variable "enable_diagnostics" {
  description = "Habilita el envío de métricas y logs de la MI a Log Analytics."
  type        = bool
  default     = true
}

variable "diagnostics_log_analytics_workspace_id" {
  description = "ID de Log Analytics Workspace para diagnósticos (si no se crea en el módulo)."
  type        = string
  default     = null
}

variable "diagnostic_logs" {
  description = "Categorías de logs a habilitar para la MI."
  type        = list(string)
  default     = [
    "SQLSecurityAuditEvents",
    "AutomaticTuning",
    "QueryStoreRuntimeStatistics",
    "QueryStoreWaitStatistics",
    "Errors"
  ]
}

variable "diagnostic_metrics" {
  description = "Categorías de métricas a habilitar para la MI."
  type        = list(string)
  default     = ["AllMetrics"]
}

# ==========================
# Log Analytics opcional (creación)
# ==========================
variable "create_log_analytics" {
  description = "Crear automáticamente un Log Analytics Workspace para auditoría/diagnósticos."
  type        = bool
  default     = true
}

variable "law_retention_days" {
  description = "Días de retención para el Log Analytics Workspace creado por el módulo."
  type        = number
  default     = 30
}

# ==========================
# Private Endpoints genéricos
# ==========================
variable "private_endpoints" {
  description = <<EOT
Lista de Private Endpoints a crear:
- name: nombre lógico del PE.
- target_resource_id: ID del recurso a privatizar (Storage, Key Vault, etc.).
- subresource_names: subrecursos expuestos (p.ej. ["blob"], ["vault"], ["file","queue"]).
- create_dns_zones: si es true, se crean Private DNS Zones indicadas en 'dns_zone_names' y se enlazan a la VNet.
- dns_zone_names: nombres de Private DNS Zones a crear (p.ej. ["privatelink.blob.core.windows.net"]).
- dns_zone_ids: IDs de Private DNS Zones existentes (si 'create_dns_zones' es false).
EOT
  type = list(object({
    name               = string
    target_resource_id = string
    subresource_names  = list(string)
    create_dns_zones   = optional(bool, false)
    dns_zone_names     = optional(list(string), [])
    dns_zone_ids       = optional(list(string), [])
  }))
  default = []
}

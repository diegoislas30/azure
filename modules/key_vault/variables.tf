# ================== Resource Group / Ubicación ==================
variable "rg_name" {
  description = "Nombre del Resource Group donde se creará el Key Vault"
  type        = string
}

variable "location" {
  description = "Región de Azure (ej. eastus, westeurope)"
  type        = string
}

# ================== Key Vault Básico ==================
variable "name" {
  description = "Nombre del Key Vault (debe ser único globalmente, 3-24 caracteres alfanuméricos y guiones)"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.name))
    error_message = "El nombre del Key Vault debe tener entre 3 y 24 caracteres alfanuméricos y guiones."
  }
}

variable "sku_name" {
  description = "SKU del Key Vault: standard o premium"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name debe ser 'standard' o 'premium'."
  }
}

# ================== Características del Key Vault ==================
variable "enabled_for_deployment" {
  description = "Permite que Azure Virtual Machines recuperen certificados almacenados como secretos"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Permite que Azure Disk Encryption recupere secretos y claves"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Permite que Azure Resource Manager recupere secretos del Key Vault"
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Habilita autorización basada en RBAC en lugar de access policies"
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "Habilita protección contra purga (no se puede eliminar permanentemente hasta después del período de retención)"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Días de retención para soft delete (7-90 días)"
  type        = number
  default     = 90
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days debe estar entre 7 y 90 días."
  }
}

variable "public_network_access_enabled" {
  description = "Permite el acceso público al Key Vault"
  type        = bool
  default     = false
}

# ================== Network ACLs ==================
variable "enable_network_acls" {
  description = "Habilita las reglas de red (Network ACLs)"
  type        = bool
  default     = true
}

variable "network_acls_bypass" {
  description = "Servicios que pueden bypassear las reglas de red"
  type        = string
  default     = "AzureServices"
  validation {
    condition     = contains(["AzureServices", "None"], var.network_acls_bypass)
    error_message = "network_acls_bypass debe ser 'AzureServices' o 'None'."
  }
}

variable "network_acls_default_action" {
  description = "Acción por defecto para las reglas de red"
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.network_acls_default_action)
    error_message = "network_acls_default_action debe ser 'Allow' o 'Deny'."
  }
}

variable "network_acls_ip_rules" {
  description = "Lista de IPs públicas permitidas (en formato CIDR)"
  type        = list(string)
  default     = []
}

variable "vnet_subnet_ids" {
  description = "Map de subnet IDs del módulo vnets (output subnet_ids del módulo vnets)"
  type        = map(string)
  default     = {}
}

variable "network_acls_subnet_names" {
  description = "Lista de nombres de subnets permitidas (deben existir en vnet_subnet_ids)"
  type        = list(string)
  default     = []
}

# ================== Access Policies (solo si RBAC está deshabilitado) ==================
variable "access_policies" {
  description = "Mapa de access policies para el Key Vault (solo se usa si enable_rbac_authorization = false)"
  type = map(object({
    object_id               = string
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}

# ================== Private Endpoint ==================
variable "private_endpoint_enabled" {
  description = "Habilita la creación de un Private Endpoint para el Key Vault"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_name" {
  description = "Nombre de la subnet donde se creará el Private Endpoint (debe existir en vnet_subnet_ids)"
  type        = string
  default     = null
}

variable "private_endpoint_private_dns_zone_ids" {
  description = "Lista de IDs de Private DNS Zones para asociar al Private Endpoint"
  type        = list(string)
  default     = []
}

# ================== Tags ==================
variable "tags" {
  description = "Tags para asignar a los recursos del Key Vault"
  type = object({
    UDN      = string
    OWNER    = string
    xpeowner = string
    proyecto = string
    ambiente = string
  })
}

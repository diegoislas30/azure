# ================== Resource Group / ubicación ==================
variable "rg_name" {
  description = "Nombre del Resource Group."
  type        = string
}

variable "location" {
  description = "Región de Azure (p.ej. eastus, westeurope)."
  type        = string
}

# ================== Básico ==================
variable "name" {
  description = "Nombre del Storage Account."
  type        = string
}

variable "storage_type" {
  description = "Tipo preferido: 'blob' o 'file'."
  type        = string
  validation {
    condition     = contains(["blob", "file"], lower(var.storage_type))
    error_message = "storage_type debe ser 'blob' o 'file'."
  }
}

variable "performance" {
  description = "Performance: Standard o Premium."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.performance)
    error_message = "performance debe ser Standard o Premium (con mayúscula inicial)."
  }
}

variable "redundancy" {
  description = "Redundancia: LRS | ZRS | GRS | GZRS | RAGRS | RAGZRS."
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS","ZRS","GRS","GZRS","RAGRS","RAGZRS"], upper(var.redundancy))
    error_message = "Usa: LRS, ZRS, GRS, GZRS, RAGRS o RAGZRS."
  }
}

# ================== Avanzado ==================
variable "access_tier" {
  description = "Hot o Cool. (Sólo aplica para StorageV2/BlobStorage)."
  type        = string
  default     = "Hot"
  validation {
    condition     = contains(["Hot","Cool"], var.access_tier)
    error_message = "access_tier debe ser Hot o Cool."
  }
}

variable "min_tls_version" {
  description = "TLS mínimo soportado."
  type        = string
  default     = "TLS1_2"
}

# ================== Network ==================
variable "allow_public_network" {
  description = "true = público (sin network rules). false = privado (con network rules)."
  type        = bool
  default     = false
}

variable "network_bypass" {
  description = "Servicios que bypassean la red."
  type        = list(string)
  default     = ["AzureServices"]
}

variable "allowed_ip_rules" {
  description = "IPs públicas permitidas cuando es privado."
  type        = list(string)
  default     = []
}

variable "allowed_subnet_ids" {
  description = "Subnets permitidas cuando es privado."
  type        = list(string)
  default     = []
}

# ===== Private Endpoint (opcional) =====
variable "private_endpoint_enabled" {
  description = "Habilita Private Endpoint."
  type        = bool
  default     = false
}

variable "private_endpoint_subresource_name" {
  description = "Subrecurso del PE (blob | file)."
  type        = string
  default     = "blob"
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID para el Private Endpoint (requerido si se habilita PE)."
  type        = string
  default     = null
}

variable "private_endpoint_private_dns_zone_ids" {
  description = "IDs de Private DNS Zones asociadas al PE."
  type        = list(string)
  default     = []
}

# ================== Tags ==================
variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = object({
    UDN       = string
    OWNER     = string
    xpeowner  = string
    proyecto  = string
    ambiente  = string
  })
  
}

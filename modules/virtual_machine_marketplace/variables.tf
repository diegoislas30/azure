variable "vm_name" {
  description = "Nombre de la máquina virtual (único dentro del RG)."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group."
  type        = string
}

variable "location" {
  description = "Región de Azure (ej. southcentralus)."
  type        = string
}

variable "subnet_id" {
  description = "ID de la Subnet donde nacerá la NIC (sin IP pública)."
  type        = string
}

variable "os_type" {
  description = "Tipo de SO: 'linux' o 'windows'."
  type        = string
  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "os_type debe ser 'linux' o 'windows'."
  }
}

variable "vm_size" {
  description = "Tamaño de la VM. Default: el más pequeño recomendado."
  type        = string
  default     = "Standard_B1s"
}

variable "zone" {
  description = "Availability Zone (1,2,3). Dejar null para no usar AZ."
  type        = string
  default     = null
}

variable "security_type" {
  description = "Tipo de seguridad: TrustedLaunch (default) o Standard."
  type        = string
  default     = "TrustedLaunch"
  validation {
    condition     = contains(["trustedlaunch", "standard"], lower(var.security_type))
    error_message = "security_type debe ser 'TrustedLaunch' o 'Standard'."
  }
}

# Imagen de Marketplace
variable "marketplace_image" {
  description = "Referencia de imagen de Azure Marketplace."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string # 'latest' permitido
  })
}

variable "admin_username" {
  description = "Usuario administrador."
  type        = string
  default     = "spyderadmin"
}

variable "admin_password" {
  description = "Contraseña administrador (cumplir complejidad de Azure)."
  type        = string
  sensitive   = true
}

# Disco del sistema (OS Disk)
variable "os_disk_size_gb" {
  description = "Tamaño del OS Disk en GB. Default 128 GB."
  type        = number
  default     = 128
}

variable "os_disk_storage_account_type" {
  description = "SKU del OS Disk: StandardSSD_LRS (default), Premium_LRS, etc."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "os_disk_caching" {
  description = "Caching del OS Disk: None, ReadOnly, ReadWrite. Default ReadWrite."
  type        = string
  default     = null
}

# Data Disks
variable "data_disks" {
  description = <<EOT
Lista de data disks a adjuntar. Cada objeto:
{
  lun                  = number     # requerido (0..63, no repetir)
  size_gb              = number     # requerido
  caching              = optional(string, "ReadOnly")  # None | ReadOnly | ReadWrite
  storage_account_type = optional(string, "StandardSSD_LRS")
}
EOT
  type = list(object({
    lun                  = number
    size_gb              = number
    caching              = optional(string)
    storage_account_type = optional(string)
  }))
  default = []
}

# Redes
variable "enable_accelerated_networking" {
  description = "Habilita Accelerated Networking en la NIC (si el tamaño lo soporta)."
  type        = bool
  default     = false
}

# Boot diagnostics (opcional)
variable "boot_diagnostics_storage_uri" {
  description = "URI del Storage Account para boot diagnostics (opcional)."
  type        = string
  default     = null
}

# Tags (igual que tu módulo anterior)
variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type = object({
    UDN       = string
    OWNER     = string
    xpeowner  = string
    proyecto  = string
    ambiente  = string
  })
}

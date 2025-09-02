variable "vm_name" {
  description = "Nombre de la VM"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group destino"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet para la NIC"
  type        = string
}

variable "vm_size" {
  description = "Tamaño de la instancia"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Usuario admin local"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Password admin (mejor usar KeyVault/secret en CI)"
  type        = string
  sensitive   = true
  default     = "ChangeMe!12345"
}

variable "os_disk_size_gb" {
  description = "Tamaño del OS disk"
  type        = number
  default     = 127
}

variable "data_disks" {
  description = "Discos de datos"
  type = list(object({
    lun           = number
    size_gb       = number
    caching       = string            # None | ReadOnly | ReadWrite
    storage_type  = string            # StandardSSD_LRS | Premium_LRS | ...
  }))
  default = []
}

variable "allow_rdp_from_cidr" {
  description = "CIDR permitido para RDP (ej. 10.0.0.0/8). Si null, todo inbound denegado."
  type        = string
  default     = null
}

variable "tags" {
  description = "Etiquetas"
  type        = map(string)
  default     = {}
}

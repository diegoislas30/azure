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
  description = "ID de la subnet donde se conectará la NIC"
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
  description = "Password admin (usa KeyVault/secret en CI en prod)"
  type        = string
  sensitive   = true
  default     = "ChangeMe!12345"
}

variable "os_disk_size_gb" {
  description = "Tamaño del OS disk (GB)"
  type        = number
  default     = 127
}

variable "data_disks" {
  description = "Discos de datos a adjuntar"
  type = list(object({
    lun           = number
    size_gb       = number
    caching       = string            # None | ReadOnly | ReadWrite
    storage_type  = string            # StandardSSD_LRS | Premium_LRS | ...
  }))
  default = []
}


# Reglas mínimas dentro del módulo (solo si se crea NSG interno)
variable "allow_rdp_from_cidr" {
  description = "CIDR permitido para RDP. Si es null, no se crea regla (todo inbound denegado)."
  type        = string
  default     = null
}

# NSG externo (si lo pasas, lo asociamos a la NIC)
variable "nsg_id" {
  description = "ID de un NSG externo a asociar a la NIC"
  type        = string
  default     = null
}

# Si true, crea un NSG interno en este módulo y lo asocia a la NIC
variable "create_builtin_nsg" {
  description = "Crear NSG propio del módulo (se ignora si pasas nsg_id)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Etiquetas"
  type        = map(string)
  default     = {}
}

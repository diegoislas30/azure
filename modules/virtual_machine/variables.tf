variable "vm_name" {
  description = "Nombre de la máquina virtual."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se creará la VM."
  type        = string
}

variable "location" {
  description = "Región/Location de la VM."
  type        = string
}

variable "vm_size" {
  description = "SKU/tamaño de la VM (por ejemplo, Standard_DS2_v2)."
  type        = string
}

variable "os_type" {
  description = "Sistema operativo: \"linux\" o \"windows\". Por defecto se despliega Windows."
  type        = string
  default     = "windows"

  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "os_type debe ser \"linux\" o \"windows\"."
  }
}

variable "admin_username" {
  description = "Usuario administrador."
  type        = string
}

variable "admin_password" {
  description = "Contraseña del administrador (obligatoria)."
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde se conectará la NIC."
  type        = string
}

variable "private_ip_address" {
  description = "IP privada estática (opcional)."
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Modo de asignación cuando private_ip_address es null (Dynamic/Static)."
  type        = string
  default     = "Dynamic"
}

variable "enable_public_ip" {
  description = "Si true, crea y asocia una IP pública. Por defecto las VMs nacen sin IP pública."
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "SKU de la IP pública."
  type        = string
  default     = "Standard"
}

variable "public_ip_allocation_method" {
  description = "Asignación de la IP pública (Static o Dynamic)."
  type        = string
  default     = "Static"
}

variable "public_ip_domain_name_label" {
  description = "Etiqueta DNS para la IP pública (opcional)."
  type        = string
  default     = null
}

variable "network_security_group_id" {
  description = "ID de un NSG para asociar a la NIC (opcional)."
  type        = string
  default     = null
}

variable "source_image_id" {
  description = "ID de la imagen en Azure Compute Gallery."
  type        = string
}

variable "os_disk" {
  description = "Configuración del disco del sistema operativo."
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = number
  })
  default = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }
}

variable "tags" {
  description = "Etiquetas estándar del proyecto."
  type = object({
    UDN      = string
    OWNER    = string
    xpeowner = string
    proyecto = string
    ambiente = string
  })
}

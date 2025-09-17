variable "vm_name" {
  description = "Nombre de la VM"
  type        = string
}

variable "location" {
  description = "Región"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subnet donde se desplegará la VM"
  type        = string
}

variable "public_ip_id" {
  description = "ID de la IP pública (opcional)"
  type        = string
  default     = null
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Usuario administrador"
  type        = string
}

variable "admin_password" {
  description = "Contraseña administrador"
  type        = string
  sensitive   = true
}

variable "os_disk_size" {
  description = "Tamaño del disco OS en GB"
  type        = number
  default     = 64
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  type    = string
  default = "22_04-lts-gen2"
}

variable "image_version" {
  type    = string
  default = "latest"
}

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

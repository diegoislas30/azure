variable "vm_name" {
    type = string
    description = "Nombre de la máquina virtual"
}

variable "resource_group_name" {
    type = string
    description = "Nombre del resource group"
}

variable "location" {
    type = string
    description = "Ubicación de la máquina virtual"
}

variable "tags" {
    type = object({
        UDN = string
        OWNER = string
        xpeowner = string
        proyecto = string
        ambiente = string
    })
}

variable "subnet_id" {
    type = string
    description = "ID de la subred"
}


variable "vm_size" {
    type = string
    description = "Tamaño de la máquina virtual"
    default = "Standard_B1s"

}

variable "admin_username" {
    type = string
    description = "Nombre de usuario administrador"
    default = "guestfemsa"
}

variable "admin_password" {
    type = string
    description = "Contraseña administrador"
    default = "ZaVeCer1029Adm"
}

variable "os_disk_name" {
    type = string
    description = "Nombre del disco de sistema"
    default = "osdisk"
}

variable "os_disk_size_gb" {
    type = number
    description = "Tamaño del disco de sistema"
    default = 127
}

variable "data_disks" {
  description = "Lista de discos de datos"
  type = list(object({
    lun          = number
    size_gb      = number
    caching      = string
    storage_type = string
  }))
  default = []
}







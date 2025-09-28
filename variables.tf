# variables.tf (en el root)
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_password" {
  description = "Administrator password for the VM"
  type        = string
  sensitive   = true
  default     = "ZaVeCer1029Adm"
}

variable "admin_username" {
  type    = string
  default = "guestfemsa"
}

variable "resourece_group_name" {
  type        = string
  description = "Nombre del Resource Group a crear"
}

variable "location" {
  type        = string
  description = "Ubicación del Resource Group"
  default     = "West Europe"
}

variable "tags" {
  type        = map(string)
  description = "Tags para los recursos"
  default     = { proyecto = "iac", entorno = "dev" }
}
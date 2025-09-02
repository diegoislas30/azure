variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "id" {
  description = "The ID of the resource group"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource group"
  type        = object({
    UDN       = string
    OWNER     = string
    xpeowner  = string
    proyecto  = string
    ambiente  = string
  })
  
}



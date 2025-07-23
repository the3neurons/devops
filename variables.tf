variable "rg-name" {
  description = "Resource group name"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = ""
}

variable "sa-name" {
  description = "Storage account name"
  type        = string
  default     = ""
}

variable "training-data-sc-name" {
  description = "Storage container name for the training data"
  type = string
  default = ""
}

variable "models-sc-name" {
  description = "Storage container name for the models"
  type = string
  default = ""
}

variable "service-plan" {
  description = "Service plan name"
  type        = string
  default     = "" 
}
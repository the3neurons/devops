variable "rg-name" {
  description = "Resource group name"
  type        = string
  default     = "rgthe3neurons"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "francecentral"
}

variable "sa-name" {
  description = "Storage account name"
  type        = string
  default     = "stgthe3neurons"
}

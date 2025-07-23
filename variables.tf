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

variable "mysql_user" {
  description = "MySQL username"
  type = string
  default = "fake_user"
}

variable "mysql_password" {
  description = "MySQL password"
  type = string
  default = "Fake_password_0"
}

variable "mysql_dbname" {
  description = "MySQL database name"
  type = string
  default = "fake-dbname"
}

variable "mysql_server_name" {
  description = "MySQL server name"
  type = string
  default = "fake-server-name"
}

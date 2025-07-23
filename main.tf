resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg-name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.sa-name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "training-data" {
  name                  = "training-data"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  app_settings = {
    MYSQL_HOST                     = azurerm_mysql_flexible_server.mysql.fqdn
    MYSQL_USER                     = var.mysql_user
    MYSQL_PASSWORD                 = var.mysql_password
    MYSQL_DATABASE                 = var.mysql_dbname
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
  }

  site_config {
    application_stack {
      node_version = "22-lts"
    }

    always_on = true

    cors {
      allowed_origins = ["*"]
    }
  }

  ftp_publish_basic_authentication_enabled       = true
  webdeploy_publish_basic_authentication_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = var.mysql_dbname
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  administrator_login    = var.mysql_user
  administrator_password = var.mysql_password
  version                = "8.0.21"
  sku_name               = "B_Standard_B1ms"
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_mysql_flexible_server.mysql.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = "OFF"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_service_plan" "asp" {
  name                = "asp-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B2"
}

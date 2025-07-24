resource "azurerm_resource_group" "rg" {
  name     = var.rg-name
  location = var.location
}

resource "random_string" "name" {
  length  = 8
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                     = var.sa-name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "training-data" {
  name                  = var.training-data-sc-name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "models" {
  name                  = var.models-sc-name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "asp" {
  name                = var.service-plan
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B2"
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-${random_string.name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id


  site_config {
    application_stack {
      python_version = "3.11"
    }
    app_command_line = "cd python/backend && apt install tree && tree && pip install -r requirements.txt && flask run"

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

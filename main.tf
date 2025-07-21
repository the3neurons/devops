provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.rg-name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = var.sa-name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" // Replicated 3 times in a single datacenter
}

resource "azurerm_storage_container" "training-data" {
  name                  = "training-data"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

resource "azurerm_container_registry" "container-registry" {
  name                = "crthe3neurons"
  location            = var.location
  resource_group_name = var.rg-name
  sku                 = "Basic" // Cheapest tier
}

resource "azurerm_application_insights" "ai" {
  name                = "aithe3neurons"
  location            = var.location
  resource_group_name = var.rg-name
  application_type    = "web"
}

resource "azurerm_key_vault" "kv" {
  name                = "kvthe3neurons"
  location            = var.location
  resource_group_name = var.rg-name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_machine_learning_workspace" "ml-ws" {
  name                    = "mlwsthe3neurons"
  application_insights_id = azurerm_application_insights.ai.id
  key_vault_id            = azurerm_key_vault.kv.id
  location                = var.location
  resource_group_name     = var.rg-name
  storage_account_id      = azurerm_storage_account.sa.id

  identity {
    type = "SystemAssigned"
  }
}

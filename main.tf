provider "azurerm" {
  features {}
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
  account_replication_type = "LRS" // Replicated 3 times in a single datacenter
}

resource "azurerm_storage_container" "training-data" {
  name                  = "training-data"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}

# resource "azurerm_container_registry" "acr" {
#   name                = "cvdregistry"
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "Basic"
#   admin_enabled       = true
# }
#
# resource "azurerm_ml_workspace" "mlw" {
#   name                = "cvd-mlw"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku_name            = "Basic"
# }

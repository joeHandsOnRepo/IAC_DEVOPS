provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "Terraform_RG" {
  name     = "Terraform_RG"
  location = "East US"
}

resource "azurerm_key_vault" "Terraform_kv" {
  name                        = "Terraform_kv"
  location                    = azurerm_resource_group.Terraform_RG.location
  resource_group_name         = azurerm_resource_group.Terraform_RG.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
resource "azurerm_log_analytics_workspace" "Terraform_ws" {
  name                = "Terraform_ws"
  location            = azurerm_resource_group.Terraform_RG.location
  resource_group_name = azurerm_resource_group.Terraform_RG.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_mssql_server" "terraform_server" {
  name                         = "terraform_server"
  resource_group_name          = azurerm_resource_group.Terraform_RG.name
  location                     = azurerm_resource_group.Terraform_RG.location
  version                      = "12.0"
  administrator_login          = "Student"
  administrator_login_password = "Password123!"
}

resource "azurerm_mssql_database" "terraform_db" {
  name         = "terraform_db"
  server_id    = azurerm_mssql_server.terraform_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
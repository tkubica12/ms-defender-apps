resource "azurerm_cosmosdb_account" "main" {
  name                          = "cosmos-${local.base_name}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  offer_type                    = "Standard"
  kind                          = "GlobalDocumentDB"
  public_network_access_enabled = true
  local_authentication_disabled = true

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
  tags = {
    git_commit           = "ce4e24ff0173b762e64ee4b4aaf6f52087832b39"
    git_file             = "terraform/ms-defender-apps/cosmosdb.tf"
    git_last_modified_at = "2024-09-29 07:34:18"
    git_last_modified_by = "tkubica12@gmail.com"
    git_modifiers        = "tkubica12"
    git_org              = "tkubica12"
    git_repo             = "ms-defender-apps"
    yor_name             = "main"
    yor_trace            = "ab905e1b-bf82-4d5a-a269-58b3e68e7c2b"
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "mydb"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
}

resource "azurerm_cosmosdb_sql_container" "books" {
  name                = "books"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths = ["/id"]
}

resource "azurerm_cosmosdb_sql_container" "customers" {
  name                = "customers"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths = ["/id"]
}

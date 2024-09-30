resource "azurerm_role_assignment" "storage_self" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_cosmosdb_sql_role_definition" "main" {
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  name                = "acctestsqlrole"
  assignable_scopes   = [azurerm_cosmosdb_account.main.id]

  permissions {
    data_actions = [
      "Microsoft.DocumentDB/databaseAccounts/readMetadata",
      "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*",
      "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"
    ]
  }
}

resource "azurerm_cosmosdb_sql_role_assignment" "cosmos_services_identity" {
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  role_definition_id  = azurerm_cosmosdb_sql_role_definition.main.id
  principal_id        = azurerm_user_assigned_identity.main.principal_id
  scope               = azurerm_cosmosdb_account.main.id
}

resource "azurerm_cosmosdb_sql_role_assignment" "cosmos_self" {
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  role_definition_id  = azurerm_cosmosdb_sql_role_definition.main.id
  principal_id        = data.azurerm_client_config.current.object_id
  scope               = azurerm_cosmosdb_account.main.id
}

resource "azurerm_role_assignment" "acr_deployment" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.deployment.principal_id
}

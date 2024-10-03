resource "azurerm_resource_group" "main" {
  name     = "rg-not-great-iac"
  location = "swedencentral"
  tags = {
    yor_name  = "main"
    yor_trace = "cb2ed409-f813-4d6a-b00d-023da85236c1"
  }
}
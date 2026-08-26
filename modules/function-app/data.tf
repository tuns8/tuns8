data "azurerm_subscription" "current" {
}

data "azurerm_role_definition" "vault_reader" {
  role_definition_id = "4633458b-17de-408a-b874-0445c86b69e6"
}
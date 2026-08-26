data "azurerm_subscription" "current" {
}
data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "vault_admin" {
  role_definition_id = "b86a8fe4-44ce-4948-aee5-eccb2c155cd7"
}

data "azurerm_role_definition" "functions_admin" {
  role_definition_id = "de139f84-1756-47ae-9be6-808fbbe84772"
}


data "azurerm_role_definition" "vault_reader" {
  role_definition_id = "4633458b-17de-408a-b874-0445c86b69e6"
}


data "azurerm_location" "locations" {
  for_each = local.locations
  location = each.value

}

# Retrieve ADO agent IPs from 'Service Tag' data source
data "azurerm_network_service_tags" "azure_devops" {
  location = data.azurerm_location.locations["primary"].location
  service  = "AzureDevOps"

}

# Retrieve Azure DataCentre IPs for UKSouth and UKWest regions from 'Service Tag' data source
data "azurerm_network_service_tags" "azure_cloud" {
  for_each = toset(["uksouth", "ukwest"])

  location        = data.azurerm_location.locations["primary"].location
  service         = "AzureCloud"
  location_filter = each.value

}







 

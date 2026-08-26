resource "random_string" "id" {
  length  = 6
  special = false
  upper   = false
}
# Creation of Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.main_project}${var.sub_project}${var.environment}${random_string.id.result}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_workspace_retention_in_days

  tags = var.tags
}

# Application Insights Resource
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.main_project}${var.sub_project}${var.environment}${random_string.id.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_type

  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = var.tags
}

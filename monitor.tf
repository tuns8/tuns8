module "az-monitor" {
  source                                    = "./module/monitor"
  main_project                              = var.main_project
  sub_project                               = var.sub_project
  environment                               = var.environment
  location                                  = var.location
  resource_group_name                       = var.resource_group_name
  log_analytics_workspace_sku               = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  application_type                          = var.application_type

}


resource "random_integer" "amp_id" {
  max = 999
  min = 1
}

resource "azurerm_monitor_private_link_scope" "ampls_scope" {
  name                  = "pls-${var.project}-${random_integer.amp_id.result}-${var.environment}"
  resource_group_name   = var.resource_group_name
  ingestion_access_mode = "PrivateOnly"
}


resource "azurerm_monitor_private_link_scoped_service" "law_link" {
  name                = "pls-${var.project}-law-${var.environment}"
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.ampls_scope.name
  linked_resource_id  = module.az-monitor.log_analytics_workspace_id
}

resource "azurerm_monitor_private_link_scoped_service" "appsinsight_link" {
  name                = "pls-${var.project}-appi-${var.environment}"
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.ampls_scope.name
  linked_resource_id  = module.az-monitor.application_insights_id
}

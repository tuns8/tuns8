output "application_insights_id" {
  description = "The ID of the Application Insights component."
  value       = azurerm_application_insights.app_insights.id
}

output "application_insights_name" {
  description = "The name of the Application Insights component."
  value       = azurerm_application_insights.app_insights.name
}

output "application_insights_instrumentation_key" {
  description = "The Instrumentation Key for the Application Insights component."
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.name
}
output "app_insights_connection_string" {
  description = "Connection string value for AppInsights"
  value       = azurerm_application_insights.app_insights.connection_string
  sensitive = true
}
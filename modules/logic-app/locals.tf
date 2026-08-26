locals {
  min_tls_version = 1.2
  default_app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" : var.app_insights_connection_string == "" ? null : var.app_insights_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY" : var.app_insights_connection_string == "" ? null : var.app_insights_instrumentation_key
    "FUNCTIONS_WORKER_RUNTIME" : "dotnet"
    "public_network_access" : var.public_network_access == true ? "Enabled" : "Disabled"
  }
}
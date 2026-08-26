output "id" {
  description = "The id of the functionApp"
  value       = azurerm_logic_app_standard.logic_app.id
}

output "name" {
  description = "The name of the functionApp"
  value       = azurerm_logic_app_standard.logic_app.name
}

output "logic_app_default_hostname" {
  description = "Default hostname of the functionApp"
  value       = azurerm_logic_app_standard.logic_app.default_hostname
}

output "logic_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the functionApp"
  value       = azurerm_logic_app_standard.logic_app.outbound_ip_addresses
}

output "service_plan_name" {
  description = "Generated service plan name"
  value       = try(azurerm_service_plan.service_plan[0].name, null)
}

output "service_plan_id" {
  description = "Generated service plan id"
  value       = try(azurerm_service_plan.service_plan[0].id, null)
}

output "storage_account_name" {
  description = "Generated storage account name"
  value       = try(azurerm_storage_account.storage_account[0].name, null)
}


output "storage_account_id" {
  description = "Generated storage account name"
  value       = try(azurerm_storage_account.storage_account[0].id, null)
}

output "identity_principal_id" {
  description = "Principal ID of the logic app's managed identity."
  value       = one(azurerm_logic_app_standard.logic_app.identity[*].principal_id)
}

output "identity_tenant_id" {
  description = "Tenant ID of the logic app's managed identity."
  value       = one(azurerm_logic_app_standard.logic_app.identity[*].tenant_id)
}

output "id" {
  description = "The id of the functionApp"
  value       = var.operating_system == "Linux" ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
}

output "name" {
  description = "The name of the functionApp"
  value       = var.operating_system == "Linux" ? azurerm_linux_function_app.function_app[0].name : azurerm_windows_function_app.function_app[0].name
}

output "slot_id" {
  description = "The id of the functionApps slot"
  value       = var.operating_system == "Linux" ? azurerm_linux_function_app_slot.function_app_slot[0].id : azurerm_windows_function_app_slot.function_app_slot[0].id
}

output "function_app_default_hostname" {
  description = "Default hostname of the functionApp"
  value       = var.operating_system == "Linux" ? azurerm_linux_function_app.function_app[0].default_hostname : azurerm_windows_function_app.function_app[0].default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the functionApp"
  value       = var.operating_system == "Linux" ? azurerm_linux_function_app.function_app[0].outbound_ip_address_list : azurerm_windows_function_app.function_app[0].outbound_ip_address_list
}

output "service_plan_id" {
  description = "Generated service plan id"
  value       = var.use_existing_service_plan ? var.service_plan_id : var.operating_system == "Linux" ? try(azurerm_service_plan.fa_linux_service_plan[0].id, null) : try(azurerm_service_plan.fa_windows_service_plan[0].id, null)
}



output "identity_principal_id" {
  description = "Principal ID of the function app's managed identity."
  value       = var.operating_system == "Windows" ? azurerm_windows_function_app.function_app[0].identity[0].principal_id : azurerm_linux_function_app.function_app[0].identity[0].principal_id
}

output "identity_tenant_id" {
  description = "Tenant ID of the function app's managed identity."
  value       = var.operating_system == "Windows" ? azurerm_windows_function_app.function_app[0].identity[0].tenant_id : azurerm_linux_function_app.function_app[0].identity[0].tenant_id
}

output "staging_identity_principal_id" {
  description = "Principal ID of the function app staging slot's managed identity."
  value       = var.operating_system == "Windows" ? azurerm_windows_function_app_slot.function_app_slot[0].identity[0].principal_id : azurerm_linux_function_app_slot.function_app_slot[0].identity[0].principal_id
}

output "staging_identity_tenant_id" {
  description = "Tenant ID of the function app staging slot's managed identity."
  value       = var.operating_system == "Windows" ? azurerm_windows_function_app_slot.function_app_slot[0].identity[0].tenant_id : azurerm_linux_function_app_slot.function_app_slot[0].identity[0].tenant_id
}

output "storage_account_id" {
  description = "Generated storage account id"
  value       = try(azurerm_storage_account.storage_account[0].id, null)
}

output "storage_access_key" {
  description = "Generated storage account id"
  value       = try(azurerm_storage_account.storage_account[0].primary_access_key, null)
}

output "storage_account_name" {
  description = "Generated storage account name"
  value       = try(azurerm_storage_account.storage_account[0].name, null)
}

output "storage_account_ids" {
  value = azurerm_storage_account.storage_account[*].id
}

output "storage_connection_string" {
  value = try(azurerm_key_vault_secret.connection_string[0].value, null)
}

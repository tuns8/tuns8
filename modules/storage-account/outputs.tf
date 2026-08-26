output "id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "primary_access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
  description = "The primary access key of the storage account."
}

output "primary_connection_string" {
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
  description = "The connection string associated with the primary location."
}
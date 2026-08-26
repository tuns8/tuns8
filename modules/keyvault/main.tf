data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "main" {
  name                            = "knx-${var.project}-${var.environment}${local.identifier}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  public_network_access_enabled   = var.public_network_access_enabled
  purge_protection_enabled        = true
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  enable_rbac_authorization       = true
  enabled_for_deployment          = var.allow_azure_vm_secret_retrieval
  enabled_for_disk_encryption     = var.allow_azure_disk_encryption_secret_retrieval
  enabled_for_template_deployment = var.allow_arm_secret_retrieval
  tags                            = var.tags

# if the environment provided is preprod/production then incoming traffic is denied outside of ip rules / subnet rules
  network_acls {
    bypass = var.nacls_bypass
    default_action = can(regex("^(stg|pprod|preprod|prd|prod)$", lower(var.environment))) ?  "Deny" : var.nacls_default_action
    ip_rules = var.allowed_ips
    virtual_network_subnet_ids = var.subnet_ids
  }
}



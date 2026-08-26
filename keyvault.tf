module "keyvault" {
  source                        = "./module/Keyvault"
  project                       = var.project
  environment                   = var.environment
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tags                          = var.tags
  public_network_access_enabled = true
nacls_default_action = "Deny"
allowed_ips = distinct(flatten(
    [
      data.azurerm_network_service_tags.azure_devops.ipv4_cidrs,
      [for k, v in data.azurerm_network_service_tags.azure_cloud : v.ipv4_cidrs]
    ]
  ))
}



resource "azurerm_role_assignment" "funct_secrete_access" {
  scope              = module.keyvault.id
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_admin.id])
  principal_id       = "dca80399-4692-4e70-9464-25ee5eae538a"
}

resource "azurerm_role_assignment" "fa_ma_access" {
  scope              = module.keyvault.id
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_reader.id])
  principal_id       = azurerm_user_assigned_identity.fa_user_identity.principal_id
}




resource "azurerm_role_assignment" "funct_secrete_access_tunde" {
  scope              = module.keyvault.id
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_admin.id])
  principal_id       = "424d146c-9841-4e6f-9e73-447cb69cdb29"
}


resource "azurerm_role_assignment" "la_ma_access" {
  scope              = module.keyvault.id
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_reader.id])
  principal_id       = module.az-logic-app.identity_principal_id
}



resource "azurerm_role_assignment" "faex_ma_access" {
  scope              = module.keyvault.id
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_reader.id])
  principal_id       = module.az-function-app-ext.identity_principal_id
}


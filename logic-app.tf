module "az-logic-app" {
  depends_on = [ azurerm_private_endpoint.logic_storage ]
  source                           = "./module/Logic-app"
  appName                          = var.appName
  resource_group_name              = var.resource_group_name
  environment                      = var.environment
  project                          = var.project
  location                         = var.location
  subnet_id                        = module.network-hub.subnet_ids["lapp-outbound"]
  app_insights_connection_string   = module.az-monitor.app_insights_connection_string
  app_insights_instrumentation_key = module.az-monitor.application_insights_instrumentation_key
  app_settings                     = var.app_settings
  public_network_access            = var.allow_public_access_la
  use_32_bit_worker_process        = var.use_32_bit_worker_process
  use_existing_storage_account     = true
  storage_account_name             = module.az-storage_la.name
  storage_access_key               = module.az-storage_la.primary_access_key
  identity_ids                     = [azurerm_user_assigned_identity.user_identity.id]
  identity_type                    = var.identity_type
  maximum_elastic_worker_count     = 3
  elastic_instance_minimum = 2
 
  
}



resource "azurerm_user_assigned_identity" "user_identity" {
  name                = "umi-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
}
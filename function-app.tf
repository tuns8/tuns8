module "az-function-app" {
  depends_on = [ azurerm_private_endpoint.function_int_storage ]
  source                                   = "./module/function-app"
  resource_group_name                      = var.resource_group_name
  subnet_id                                = module.network-hub.subnet_ids["funct-outbound"]
  environment                              = var.environment
  appName                                  = "${var.project}-${var.appName}internal"
  operating_system                         = var.operating_system
  application_insights_connection_string   = module.az-monitor.app_insights_connection_string
  application_insights_instrumentation_key = module.az-monitor.application_insights_instrumentation_key
  use_existing_storage_account             = true
  storage_account_name                     = module.az-storage_int.name
  storage_access_key                       = module.az-storage_int.primary_access_key
  public_network_access                    = var.allow_public_access_funct_ext
  application_stack_dotnet_version = var.application_stack_dotnet_version
  application_stack_use_dotnet_isolated_runtime = true
   identity_type = var.identity_type
  identity_ids = [azurerm_user_assigned_identity.fa_user_identity.id]
  key_vault_reference_identity_id = azurerm_user_assigned_identity.fa_user_identity.id

      main_app_settings = merge(var.main_app_settings, {
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=${module.az-storage_int.name};AccountKey=${module.az-storage_int.primary_access_key};EndpointSuffix=core.windows.net"
    "WEBSITE_CONTENTSHARE" = "internal-${var.environment}-share"
  })

    staging_slot_settings = merge(var.staging_slot_settings, {
     "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=${module.az-storage_int.name};AccountKey=${module.az-storage_int.primary_access_key};EndpointSuffix=core.windows.net"
    "WEBSITE_CONTENTSHARE" = "internal-${var.environment}-share"
  })

}

module "az-function-app-ext" {
  depends_on                               =  [azurerm_private_endpoint.function_ext_storage] 
  source                                   = "./module/function-app"
  resource_group_name                      = var.resource_group_name
  subnet_id                                = module.network-hub.subnet_ids["funct-ext-outbound"]
  environment                              = var.environment
  appName                                  = "${var.project}-${var.appName}external"
  operating_system                         = var.operating_system
  application_insights_connection_string   = module.az-monitor.app_insights_connection_string
  application_insights_instrumentation_key = module.az-monitor.application_insights_instrumentation_key
  use_existing_storage_account             = true
  storage_account_name                      = module.az-storage_ext.name
  storage_access_key                       = module.az-storage_ext.primary_access_key
  public_network_access           = var.allow_public_access_funct_ext
  application_stack_dotnet_version = var.application_stack_dotnet_version
  application_stack_use_dotnet_isolated_runtime = true
  identity_ids = [azurerm_user_assigned_identity.fa_user_identity.id]
  identity_type = var.identity_type
  elastic_instance_minimum = 2
 maximum_elastic_worker_count = 4


  main_app_settings = merge(var.main_app_settings, {
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=${module.az-storage_ext.name};AccountKey=${module.az-storage_ext.primary_access_key};EndpointSuffix=core.windows.net"
    "WEBSITE_CONTENTSHARE" = "external-${var.environment}-share"
  })

    staging_slot_settings = merge(var.staging_slot_settings, {
     "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=${module.az-storage_ext.name};AccountKey=${module.az-storage_ext.primary_access_key};EndpointSuffix=core.windows.net"
    "WEBSITE_CONTENTSHARE" = "external-${var.environment}-share"
  })

}

resource "azurerm_user_assigned_identity" "fa_user_identity" {
  name                = "umi-${var.project}-${var.environment}function"
  location            = var.location
  resource_group_name = var.resource_group_name
}


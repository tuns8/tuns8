locals {
  dotnet_application_stack          = var.application_stack_dotnet_version != null ? [0] : []
  java_application_stack            = var.application_stack_java_version != null ? [0] : []
  node_application_stack            = var.application_stack_node_version != null ? [0] : []
  python_application_stack          = var.application_stack_python_version != null ? [0] : []
  powershell_core_application_stack = var.application_stack_powershell_core_version != null ? [0] : []

  default_sticky_settings           = tolist(["WEBSITE_OVERRIDE_STICKY_DIAGNOSTICS_SETTINGS"])
  default_sticky_connection_strings = tolist(["APPLICATIONINSIGHTS_CONNECTION_STRING"])


   default_app_settings = {

    "WEBSITE_OVERRIDE_STICKY_DIAGNOSTICS_SETTINGS" = 0,
    # "WEBSITE_RUN_FROM_PACKAGE" = 1,
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = 1,
  }

   default_staging_slot_app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 1,
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = 1,
  }

}
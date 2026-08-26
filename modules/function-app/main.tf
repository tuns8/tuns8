resource "random_integer" "id" {
  max = 9999
  min = 1000
}

resource "azurerm_storage_account" "storage_account" {
  count                    = var.use_existing_storage_account == false ? 1 : 0
  name                     = "sa${var.environment}${random_integer.id.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "fa_windows_service_plan" {
  count               = var.use_existing_service_plan == false && var.operating_system == "Windows" ? 1 : 0
  name                = "sp-${var.appName}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Windows"
  sku_name            = var.sku_name
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
}

resource "azurerm_key_vault_secret" "connection_string" {
  count        = var.use_existing_storage_account == false ? 1 : 0
  depends_on   = [azurerm_storage_account.storage_account]
  name         = "StorageConnectionString"
  value        = azurerm_storage_account.storage_account[0].primary_connection_string
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "function_app_vault_access" {
  count              = var.use_existing_storage_account == false ? 1 : 0
  depends_on         = [azurerm_windows_function_app.function_app]
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_reader.id])
  scope              = var.key_vault_id
  principal_id       = var.operating_system == "Windows" ? azurerm_windows_function_app.function_app[0].identity[0].principal_id : azurerm_linux_function_app.function_app[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "function_app_slot_vault_access" {
  count              = var.use_existing_storage_account == false ? 1 : 0
  depends_on         = [azurerm_linux_function_app.function_app]
  role_definition_id = join("", [data.azurerm_subscription.current.id, data.azurerm_role_definition.vault_reader.id])
  scope              = var.key_vault_id
  principal_id       = var.operating_system == "Windows" ? azurerm_windows_function_app_slot.function_app_slot[0].identity[0].principal_id : azurerm_linux_function_app_slot.function_app_slot[0].identity[0].principal_id
}

resource "azurerm_windows_function_app" "function_app" {
  count                       = var.operating_system == "Windows" ? 1 : 0
  name                        = "fa-${var.appName}-${var.environment}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  storage_account_name        = var.use_existing_storage_account == false ? null : var.storage_account_name
  storage_account_access_key  = var.use_existing_storage_account == false ? null : var.storage_access_key
  storage_key_vault_secret_id = var.use_existing_storage_account == false ? azurerm_key_vault_secret.connection_string[0].id : null
  virtual_network_subnet_id   = var.subnet_id
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  service_plan_id = var.use_existing_service_plan == false ? azurerm_service_plan.fa_windows_service_plan[0].id : var.service_plan_id
  tags            = var.tags

  public_network_access_enabled = var.public_network_access
  app_settings                  = merge(local.default_app_settings, var.main_app_settings)

  sticky_settings {
    app_setting_names       = concat(local.default_sticky_settings, var.sticky_app_settings)
    connection_string_names = concat(local.default_sticky_connection_strings, var.sticky_connection_strings)
  }

dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  site_config {
    use_32_bit_worker = var.use_32_bit_worker
   elastic_instance_minimum = var.elastic_instance_minimum
    always_on = true
    vnet_route_all_enabled            = true
    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        action      = lookup(ip_restriction.value, "action", null)
        name        = lookup(ip_restriction.value, "name", null)
        service_tag = lookup(ip_restriction.value, "service_tag", null)
        ip_address  = lookup(ip_restriction.value, "ip_address", null)
        priority    = lookup(ip_restriction.value, "priority", null)
      }
    }

    scm_ip_restriction_default_action = "Deny"
    
    scm_ip_restriction {
      action      = "Allow"
      name        = "ADO"
      service_tag = "AzureDevOps"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "uksouth"
      service_tag = "AzureCloud.UKSouth"
    }

     scm_ip_restriction {
      action      = "Allow"
      name        = "westeurope"
      service_tag = "AzureCloud.westeurope"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "ukwest"
      service_tag = "AzureCloud.UKWest"
    }

    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_instrumentation_key

    dynamic "application_stack" {
      for_each = local.dotnet_application_stack

      content {
        dotnet_version              = var.application_stack_dotnet_version
        use_dotnet_isolated_runtime = var.application_stack_use_dotnet_isolated_runtime
      }
    }

    dynamic "application_stack" {
      for_each = local.java_application_stack

      content {
        java_version = var.application_stack_java_version
      }
    }

    dynamic "application_stack" {
      for_each = local.node_application_stack

      content {
        node_version = var.application_stack_node_version
      }
    }

    dynamic "application_stack" {
      for_each = local.powershell_core_application_stack

      content {
        powershell_core_version = var.application_stack_powershell_core_version
      }
    }
  }

  lifecycle {
    # Avoid azure-generated tags with sensitive data appearing in plans/diffs
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
      app_settings
    ]
  }
}

resource "azurerm_windows_function_app_slot" "function_app_slot" {
  count           = var.operating_system == "Windows" ? 1 : 0
  name            = "staging"
  function_app_id = azurerm_windows_function_app.function_app[0].id

  storage_account_name        = var.use_existing_storage_account == false ? null : var.storage_account_name
  storage_account_access_key  = var.use_existing_storage_account == false ? null : var.storage_access_key
  storage_key_vault_secret_id = var.use_existing_storage_account == false ? azurerm_key_vault_secret.connection_string[0].id : null
  virtual_network_subnet_id   = var.subnet_id
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  tags = var.tags

  public_network_access_enabled = var.public_network_access
  app_settings                  = var.staging_slot_settings != null ? merge(local.default_staging_slot_app_settings, var.staging_slot_settings) : merge(local.default_staging_slot_app_settings, var.main_app_settings)
  
  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }

  }

  site_config {
    use_32_bit_worker = var.use_32_bit_worker
    always_on                         = true
    vnet_route_all_enabled            = true
    scm_ip_restriction_default_action = "Deny"

    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_instrumentation_key

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        action      = lookup(ip_restriction.value, "action", null)
        name        = lookup(ip_restriction.value, "name", null)
        service_tag = lookup(ip_restriction.value, "service_tag", null)
        ip_address  = lookup(ip_restriction.value, "ip_address", null)
        priority    = lookup(ip_restriction.value, "priorty", null)
      }
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "ADO"
      service_tag = "AzureDevOps"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "uksouth"
      service_tag = "AzureCloud.UKSouth"
    }

     scm_ip_restriction {
      action      = "Allow"
      name        = "westeurope"
      service_tag = "AzureCloud.westeurope"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "ukwest"
      service_tag = "AzureCloud.UKWest"
    }

    dynamic "application_stack" {
      for_each = local.dotnet_application_stack

      content {
        dotnet_version              = var.application_stack_dotnet_version
        use_dotnet_isolated_runtime = var.application_stack_use_dotnet_isolated_runtime
      }
    }

    dynamic "application_stack" {
      for_each = local.java_application_stack

      content {
        java_version = var.application_stack_java_version
      }
    }

    dynamic "application_stack" {
      for_each = local.node_application_stack

      content {
        node_version = var.application_stack_node_version
      }
    }

    dynamic "application_stack" {
      for_each = local.powershell_core_application_stack

      content {
        powershell_core_version = var.application_stack_powershell_core_version
      }
    }
  }
  lifecycle {
    # Avoid azure-generated tags with sensitive data appearing in plans/diffs
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
      app_settings
    ]
  }
}

resource "azurerm_service_plan" "fa_linux_service_plan" {
  count               = var.use_existing_service_plan == false && var.operating_system == "Linux" ? 1 : 0
  name                = "sp-${var.appName}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  
}

resource "azurerm_linux_function_app" "function_app" {
  count               = var.operating_system == "Linux" ? 1 : 0
  name                = "fa-${var.appName}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location


  storage_account_name        = var.use_existing_storage_account == false ? null : var.storage_account_name
  storage_account_access_key  = var.use_existing_storage_account == false ? null : var.storage_access_key
  storage_key_vault_secret_id = var.use_existing_storage_account == false ? azurerm_key_vault_secret.connection_string[0].id : null
  virtual_network_subnet_id   = var.subnet_id

  service_plan_id = var.use_existing_service_plan == false ? azurerm_service_plan.fa_linux_service_plan[0].id : var.service_plan_id
  tags            = var.tags
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  public_network_access_enabled = var.public_network_access
  app_settings                  = merge(local.default_app_settings, var.main_app_settings)

  sticky_settings {
    app_setting_names       = concat(local.default_sticky_settings, var.sticky_app_settings)
    connection_string_names = concat(local.default_sticky_connection_strings, var.sticky_connection_strings)
  }

 dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  site_config {
    use_32_bit_worker = var.use_32_bit_worker
    always_on = true
    vnet_route_all_enabled            = true
    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        action      = lookup(ip_restriction.value, "action", null)
        name        = lookup(ip_restriction.value, "name", null)
        service_tag = lookup(ip_restriction.value, "service_tag", null)
        ip_address  = lookup(ip_restriction.value, "ip_address", null)
        priority    = lookup(ip_restriction.value, "priorty", null)
      }
    }

    scm_ip_restriction_default_action = "Deny"
    scm_ip_restriction {
      action      = "Allow"
      name        = "ADO"
      service_tag = "AzureDevOps"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "uksouth"
      service_tag = "AzureCloud.UKSouth"
    }
     scm_ip_restriction {
      action      = "Allow"
      name        = "westeurope"
      service_tag = "AzureCloud.westeurope"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "ukwest"
      service_tag = "AzureCloud.UKWest"
    }

    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_instrumentation_key

    dynamic "application_stack" {
      for_each = local.dotnet_application_stack

      content {
        dotnet_version              = var.application_stack_dotnet_version
        use_dotnet_isolated_runtime = var.application_stack_use_dotnet_isolated_runtime
      }
    }

    dynamic "application_stack" {
      for_each = local.java_application_stack

      content {
        java_version = var.application_stack_java_version
      }
    }

    dynamic "application_stack" {
      for_each = local.node_application_stack

      content {
        node_version = var.application_stack_node_version
      }
    }

    dynamic "application_stack" {
      for_each = local.python_application_stack

      content {
        python_version = var.application_stack_python_version
      }
    }

    dynamic "application_stack" {
      for_each = local.powershell_core_application_stack

      content {
        powershell_core_version = var.application_stack_powershell_core_version
      }
    }
  }
  lifecycle {
    # Avoid azure-generated tags with sensitive data appearing in plans/diffs
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
      app_settings
    ]
  }
}

resource "azurerm_linux_function_app_slot" "function_app_slot" {
  count           = var.operating_system == "Linux" ? 1 : 0
  function_app_id = azurerm_linux_function_app.function_app[0].id
  name            = "staging"

  storage_account_name        = var.use_existing_storage_account == false ? null : var.storage_account_name
  storage_account_access_key  = var.use_existing_storage_account == false ? null : var.storage_access_key
  storage_key_vault_secret_id = var.use_existing_storage_account == false ? azurerm_key_vault_secret.connection_string[0].id : null
  virtual_network_subnet_id   = var.subnet_id
 key_vault_reference_identity_id = var.key_vault_reference_identity_id
  tags = var.tags

  public_network_access_enabled = var.public_network_access
  app_settings                  = var.staging_slot_settings != null ? merge(local.default_staging_slot_app_settings, var.staging_slot_settings) : merge(local.default_staging_slot_app_settings, var.main_app_settings)
   dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  site_config {
    use_32_bit_worker = var.use_32_bit_worker
    always_on                         = true
    vnet_route_all_enabled            = true
    scm_ip_restriction_default_action = "Deny"

    application_insights_connection_string = var.application_insights_connection_string
    application_insights_key               = var.application_insights_instrumentation_key

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        action      = lookup(ip_restriction.value, "action", null)
        name        = lookup(ip_restriction.value, "name", null)
        service_tag = lookup(ip_restriction.value, "service_tag", null)
        ip_address  = lookup(ip_restriction.value, "ip_address", null)
        priority    = lookup(ip_restriction.value, "priorty", null)
      }
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "ADO"
      service_tag = "AzureDevOps"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "uksouth"
      service_tag = "AzureCloud.UKSouth"
    }

    scm_ip_restriction {
      action      = "Allow"
      name        = "ukwest"
      service_tag = "AzureCloud.UKWest"
    }

      scm_ip_restriction {
      action      = "Allow"
      name        = "westeurope"
      service_tag = "AzureCloud.westeurope"
    }

    dynamic "application_stack" {
      for_each = local.dotnet_application_stack

      content {
        dotnet_version              = var.application_stack_dotnet_version
        use_dotnet_isolated_runtime = var.application_stack_use_dotnet_isolated_runtime
      }
    }

    dynamic "application_stack" {
      for_each = local.java_application_stack

      content {
        java_version = var.application_stack_java_version
      }
    }

    dynamic "application_stack" {
      for_each = local.node_application_stack

      content {
        node_version = var.application_stack_node_version
      }
    }

    dynamic "application_stack" {
      for_each = local.python_application_stack

      content {
        python_version = var.application_stack_python_version
      }
    }

    dynamic "application_stack" {
      for_each = local.powershell_core_application_stack

      content {
        powershell_core_version = var.application_stack_powershell_core_version
      }
    }
  }
  lifecycle {
    # Avoid azure-generated tags with sensitive data appearing in plans/diffs
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
      app_settings
    ]
  }
}

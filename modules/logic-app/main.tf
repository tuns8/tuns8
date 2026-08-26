resource "random_integer" "id" {
  max = 9999
  min = 1000
}

resource "azurerm_storage_account" "storage_account" {
  count                    = var.use_existing_storage_account == false ? 1 : 0
  name                     = "${var.project}${var.environment}${random_integer.id.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_service_plan" "service_plan" {
  count               = var.use_existing_service_plan == false ? 1 : 0
  name                = "${var.project}-${var.appName}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.service_plan_os
  sku_name            = var.sku_name
  tags                = var.tags
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
}

resource "azurerm_logic_app_standard" "logic_app" {
  name                       = "${var.project}-${var.appName}-${var.environment}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  storage_account_name       = var.use_existing_storage_account == false ? azurerm_storage_account.storage_account[0].name : var.storage_account_name
  storage_account_access_key = var.use_existing_storage_account == false ? azurerm_storage_account.storage_account[0].primary_access_key : var.storage_access_key
  client_affinity_enabled    = var.client_affinity
  app_service_plan_id        = var.use_existing_service_plan == false ? azurerm_service_plan.service_plan[0].id : var.service_plan_id
  version                    = var.runtime_version
  https_only                 = var.https_only
  client_certificate_mode    = var.client_certificate_mode
  virtual_network_subnet_id  = var.subnet_id
  public_network_access      = var.public_network_access ? "Enabled" : "Disabled"

  tags         = var.tags
  app_settings = merge(local.default_app_settings, var.app_settings)


dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  site_config {
    dotnet_framework_version         = var.dotnet_framework_version
    runtime_scale_monitoring_enabled = var.runtime_scale_monitoring_enabled
    use_32_bit_worker_process        = var.use_32_bit_worker_process
    vnet_route_all_enabled           = var.vnet_route_all_enabled
    websockets_enabled               = var.websockets_enabled
    pre_warmed_instance_count        = var.pre_warmed_instance_count # Premium sku only
    min_tls_version                  = local.min_tls_version
    linux_fx_version                 = var.linux_fx_version
    scm_type                         = var.scm_type
    scm_min_tls_version              = var.scm_min_tls_version
    scm_use_main_ip_restriction      = var.scm_use_main_ip_restriction
    http2_enabled                    = var.http2_enabled
    health_check_path                = var.health_check_path
    ftps_state                       = var.ftps_state
    elastic_instance_minimum         = var.elastic_instance_minimum
    app_scale_limit                  = var.app_scale_limit
    always_on                        = var.always_on

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        action                    = lookup(ip_restriction.value, "action", null)
        name                      = lookup(ip_restriction.value, "name", null)
        service_tag               = lookup(ip_restriction.value, "service_tag", null)
        ip_address                = lookup(ip_restriction.value, "ip_address", null)
        virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
        priority                  = lookup(ip_restriction.value, "priority", null)
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = var.scm_ip_restrictions
      content {
        action                    = lookup(scm_ip_restriction.value, "action", null)
        name                      = lookup(scm_ip_restriction.value, "name", null)
        service_tag               = lookup(scm_ip_restriction.value, "service_tag", null)
        ip_address                = lookup(scm_ip_restriction.value, "ip_address", null)
        virtual_network_subnet_id = lookup(scm_ip_restriction.value, "virtual_network_subnet_id", null)
        priority                  = lookup(scm_ip_restriction.value, "priority", null)
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = ["AzureDevOps", "AzureCloud.uksouth", "AzureCloud.ukwest"]
      content {
        action      = "Allow"
        name        = scm_ip_restriction.value
        service_tag = scm_ip_restriction.value
        priority    = 100
      }
    }
  }

  lifecycle {
    # Avoid azure-generated tags with sensitive data appearing in plans/diffs
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }
}

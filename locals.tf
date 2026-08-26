locals {
 
  private_endpoints = {
    logicapp = {
      resource_id       = module.az-logic-app.id
      subresource_names = ["sites"]
      dns_zone_ids      = [azurerm_private_dns_zone.private["webapp"].id]
    }

    functionapp = {
      resource_id       = module.az-function-app.id
      subresource_names = ["sites"]
      dns_zone_ids      = [azurerm_private_dns_zone.private["webapp"].id]
    }
    functionappext = {
      resource_id       = module.az-function-app-ext.id
      subresource_names = ["sites"]
      dns_zone_ids      = [azurerm_private_dns_zone.private["webapp"].id]
    }

    keyvault = {
      resource_id       = module.keyvault.id
      subresource_names = ["vault"]
      dns_zone_ids      = [azurerm_private_dns_zone.private["kv"].id]
    }

    # ai_service = {
    #   resource_id       = module.az-foundry.ai-id
    #   subresource_names = ["account"]
    #   dns_zone_ids      = [azurerm_private_dns_zone.private["cog"].id]
    # }
    # automation = {
    #   resource_id       = azurerm_automation_account.aac.id
    #   subresource_names = ["DSCAndHybridWorker"]
    #   dns_zone_ids      = [azurerm_private_dns_zone.private["ac"].id]
    # }

    # mssql = {
    #   resource_id       = azurerm_mssql_server.mssql.id
    #   subresource_names = ["sqlserver"]
    #   dns_zone_ids      = [azurerm_private_dns_zone.private["sql"].id]
    # }


    # datafactory = {
    #   resource_id       = module.az-datafactory.id
    #   subresource_names = ["dataFactory"]
    #   dns_zone_ids      = [azurerm_private_dns_zone.private["adf"].id]
    # }


    monitor = {
      resource_id       = azurerm_monitor_private_link_scope.ampls_scope.id
      subresource_names = ["azuremonitor"]
      dns_zone_ids = [
        azurerm_private_dns_zone.private["azure"].id, azurerm_private_dns_zone.private["ops"].id, azurerm_private_dns_zone.private["ods"].id, azurerm_private_dns_zone.private["agent"].id, azurerm_private_dns_zone.app-private["blob"].id
      ]
    }
  }
  

diagnostic_targets = {
    keyvault = {
      resource_id = module.keyvault.id
      log_categories = ["AuditEvent", "AzurePolicyEvaluationDetails"]
      enable_metrics = []
    }
    func_internal = {
      resource_id = module.az-function-app.id
      log_categories = []
      enable_metrics = ["AllMetrics"]
    }
    func_external = {
      resource_id = module.az-function-app-ext.id
      log_categories = []
      enable_metrics = ["AllMetrics"]

    }
    logic_app = {
      resource_id = module.az-logic-app.id
      log_categories = ["WorkflowRuntime"]
      enable_metrics = ["AllMetrics"]
    }
    servicebus = {
      resource_id = azurerm_servicebus_namespace.service_bus_namespace.id
      log_categories = ["OperationalLogs", "VNetAndIPFilteringLogs"]
      enable_metrics = []
    }
  }
  locations = {
    primary   = "uksouth"
    secondary = "ukwest"
  }

  # Ordered list to FORCE serialization
  storage_subresources = [
    "blob",
    "file",
    "queue",
    "table"
  ]
 

 alert_resources= {
  alert_funct_ext = {
    scopes = module.az-function-app-ext.id
  }

  alert_funct_int = {
    scopes = module.az-function-app.id
  }

  alert_logicapp = {
    scopes = module.az-logic-app.id
  }

 }
 

}

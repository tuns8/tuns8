resource "azurerm_private_endpoint" "paas-endpoints" {
  for_each = local.private_endpoints

  depends_on = [terraform_data.subnet_ready]

  name                = "pe-${each.key}${random_integer.amp_id.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network-hub.subnet_ids["endpoints"]

  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-${each.key}${var.project}${var.environment}"
    private_dns_zone_ids = each.value.dns_zone_ids
  }
}


resource "azurerm_private_endpoint" "function_int_storage" {
  count = length(local.storage_subresources)

  name                = "pe-${local.storage_subresources[count.index]}-func-int-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network-hub.subnet_ids["endpoints"]

  private_service_connection {
    name                           = "psc-${local.storage_subresources[count.index]}-func-int"
    private_connection_resource_id = module.az-storage_int.id
    subresource_names              = [local.storage_subresources[count.index]]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-func-int-${var.environment}"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.app-private[local.storage_subresources[count.index]].id
    ]
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "azurerm_private_endpoint" "function_ext_storage" {
  count = length(local.storage_subresources)

  depends_on = [
    azurerm_private_endpoint.function_int_storage
  ]

  name                = "pe-${local.storage_subresources[count.index]}-func-ext-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network-hub.subnet_ids["endpoints"]

  private_service_connection {
    name                           = "psc-${local.storage_subresources[count.index]}-func-ext"
    private_connection_resource_id = module.az-storage_ext.id
    subresource_names              = [local.storage_subresources[count.index]]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-func-ext-${var.environment}"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.app-private[local.storage_subresources[count.index]].id
    ]
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}


#private endpoint for function app ext storage accounts batch 1
resource "azurerm_private_endpoint" "logic_storage" {
  count = length(local.storage_subresources) 

  depends_on = [
    azurerm_private_endpoint.function_ext_storage
  ]

  name                = "pe-${local.storage_subresources[count.index]}-logic-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network-hub.subnet_ids["endpoints"]

  private_service_connection {
    name                           = "psc-${local.storage_subresources[count.index]}-logic"
    private_connection_resource_id = module.az-storage_la.id
    subresource_names              = [local.storage_subresources[count.index]]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-logic-${var.environment}"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.app-private[local.storage_subresources[count.index]].id
    ]
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

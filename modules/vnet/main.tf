resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.vnet_name}-${var.environment_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_prefixes

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = { for index, subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = each.value.address_prefixes

  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.service_delegation.enabled ? [each.value.service_delegation.name] : []

    content {
      name = each.value.service_delegation.name
      service_delegation {
        name    = each.value.service_delegation.service_name
        actions = each.value.service_delegation.actions
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = {
    for index, subnet in var.subnets : subnet.name => subnet
    if subnet.attach_network_security_group == true
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value.network_security_group_id

  lifecycle {
    precondition {
      condition     = each.value.network_security_group_id != null
      error_message = "Must provide a network security group ID for any subnets with `attach_network_security_group` set to 'true'."
    }
  }
}


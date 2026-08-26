
module "network-hub" {
  source                = "./module/vnet"
  resource_group_name   = var.resource_group_name
  vnet_name             = var.vnet_name
  vnet_address_prefixes = var.vnet_address_prefixes
  location              = var.location
  subnets               = var.subnets
}

resource "azurerm_private_dns_zone" "private" {
  for_each = var.private_dns_zones

  name                = each.value
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_zones_within_hub" {
  for_each              = var.private_dns_zones
  resource_group_name = var.resource_group_name
  name                  = format("%s-%s", "vnet-${var.vnet_name}-${var.environment}", "link")
  private_dns_zone_name = azurerm_private_dns_zone.private[each.key].name
  virtual_network_id    = module.network-hub.vnet_id
  
}

resource "azurerm_private_dns_zone" "app-private" {
  for_each = var.logic_app_dns

  name                = each.value
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_zones_app_link" {
  for_each              = var.logic_app_dns
  resource_group_name = var.resource_group_name
  name                  = format("%s-%s", "vnet-${var.vnet_name}-${var.environment}", "link")
  private_dns_zone_name = azurerm_private_dns_zone.app-private[each.key].name
  virtual_network_id    = module.network-hub.vnet_id
  
}




resource "terraform_data" "subnet_ready" {
  depends_on = [
    module.network-hub
  ]
}

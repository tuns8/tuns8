output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.subnets : v.name => v.id }
}

output "subnet_address_prefixes" {
  value = { for k,v in azurerm_subnet.subnets : v.name => v.address_prefixes }
}

output "name" {
  value = azurerm_virtual_network.vnet.name
}
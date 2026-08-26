output "id" {
  value       = azurerm_network_security_group.nsg.id
  description = "The network security group configuration ID."
}

output "name" {
  value       = azurerm_network_security_group.nsg.name
  description = "The name of the network security group."
}

output "inbound_rules" {
  value       = { for rule in azurerm_network_security_rule.inbounds : rule.name => rule }
  description = "A Mapping of inbound security rule names to security rule details."
}

output "outbound_rules" {
  value       = { for rule in azurerm_network_security_rule.outbounds : rule.name => rule }
  description = "A Mapping of outbound security rule names to security rule details."
}
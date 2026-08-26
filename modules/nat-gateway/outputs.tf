output "id" {
  value = azurerm_nat_gateway.nat_gateway.id
}


output "pip_id" {
  value = azurerm_public_ip.ng_public_ip.id
}
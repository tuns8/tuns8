module "nsg-network" {
  source              = "./module/network-security"
  resource_group_name = var.resource_group_name
  target_name         = "${var.project}-${var.environment}"
  inbound_rules       = var.inbound_rules

}


resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  subnet_id                 = module.network-hub.subnet_ids["endpoints"]
  network_security_group_id = module.nsg-network.id
}

# # Route table
# resource "azurerm_route_table" "rt" {
#   name                          = "${var.project}-${var.environment}-rt"
#   location                      = var.location
#   resource_group_name           = var.resource_group_name
#   bgp_route_propagation_enabled = false
# }

# # Create routes from tfvars
# resource "azurerm_route" "routes" {
#   for_each               = { for r in var.routes : r.name => r }
#   name                   = each.value.name
#   resource_group_name    = var.resource_group_name
#   route_table_name       = azurerm_route_table.rt.name
#   address_prefix         = each.value.address_prefix
#   next_hop_type          = each.value.next_hop_type
#   next_hop_in_ip_address = each.value.next_hop_in_ip_address
# }

# # Associate the route table to the provided subnet
# resource "azurerm_subnet_route_table_association" "assoc" {

#   subnet_id      = module.network-hub.subnet_ids["endpoints"]
#   route_table_id = azurerm_route_table.rt.id
# }

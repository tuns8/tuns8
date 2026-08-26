<!-- BEGIN_TF_DOCS -->
# Network Security Group Module
- This Folder contains a module for creating a network security group. The module supports attaching any number of inbound rules and/or outbound rules. Using this module will also enforce a standard naming convention.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.inbounds](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.outbounds](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the network security group. | `string` | n/a | yes |
| <a name="input_target_name"></a> [target\_name](#input\_target\_name) | (Required) The name of the target of network security group. Nsg name will be constructed as '{target\_name}-nsg' | `string` | n/a | yes |
| <a name="input_inbound_rules"></a> [inbound\_rules](#input\_inbound\_rules) | (Optional) List of inbound rule objects | <pre>list(object({<br/>    name                         = string<br/>    priority                     = number<br/>    access                       = string<br/>    protocol                     = string<br/>    source_address_prefix        = optional(string)<br/>    source_address_prefixes      = optional(list(string))<br/>    source_port_range            = optional(string)<br/>    source_port_ranges           = optional(list(string))<br/>    destination_address_prefix   = optional(string)<br/>    destination_address_prefixes = optional(list(string))<br/>    destination_port_range       = optional(string)<br/>    destination_port_ranges      = optional(list(string))<br/>    description                  = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location where the network security group is created. Defaults to uk south | `string` | `"uksouth"` | no |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | (Optional) List of outbound rule objects | <pre>list(object({<br/>    name                         = string<br/>    priority                     = number<br/>    access                       = string<br/>    protocol                     = string<br/>    source_address_prefix        = optional(string)<br/>    source_address_prefixes      = optional(list(string))<br/>    source_port_range            = optional(string)<br/>    source_port_ranges           = optional(list(string))<br/>    destination_address_prefix   = optional(string)<br/>    destination_address_prefixes = optional(list(string))<br/>    destination_port_range       = optional(string)<br/>    destination_port_ranges      = optional(list(string))<br/>    description                  = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assinged to the network security group. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The network security group configuration ID. |
| <a name="output_inbound_rules"></a> [inbound\_rules](#output\_inbound\_rules) | A Mapping of inbound security rule names to security rule details. |
| <a name="output_name"></a> [name](#output\_name) | The name of the network security group. |
| <a name="output_outbound_rules"></a> [outbound\_rules](#output\_outbound\_rules) | A Mapping of outbound security rule names to security rule details. |

# Test Cases

Tests can be found in `tests/testing.tftests.hcl`. To run tests executre `terraform init` and `terraform test` in the root of this module directory.

TODO: add details of assertions made in test suite on this module
<!-- END_TF_DOCS -->
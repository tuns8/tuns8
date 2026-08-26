<!-- BEGIN_TF_DOCS -->
# Virtual Network Module

A module to provide the capability to deploy an Azure Virtual Network, including subnets.

Features:
- Completely customizable subnets in the vnet
- Ability to declare service delegations
- Create associations between created subnets and network security groups

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.107.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.107.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_associations](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group to deploy resources to. | `string` | n/a | yes |
| <a name="input_vnet_address_prefixes"></a> [vnet\_address\_prefixes](#input\_vnet\_address\_prefixes) | Address space for the vnet. May include multiple address ranges however 1 should be suitable for most cases. | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name to give to the created vnet. Will be used in the pattern 'vnet-{var.vnet\_name}-{var.environment}'. | `string` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment being deployed, ie dev/test/preprod/live/etc. | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy the resources. Should not be changed for HO resources unless needed. | `string` | `"UK South"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create in the vnet. Exposes all configuration fields available for `azurerm_subnet`, plus allowing declaration of an attached network security group. | <pre>list(object({<br/>    name                                          = string<br/>    address_prefixes                              = list(string)<br/>    default_outbound_access_enabled               = optional(bool)<br/>    private_endpoint_network_policies             = optional(string)<br/>    private_link_service_network_policies_enabled = optional(bool)<br/>    service_endpoints                             = optional(list(string))<br/>    service_endpoint_policy_ids                   = optional(list(string))<br/>    service_delegation = optional(object({<br/>      enabled      = bool<br/>      name         = optional(string, "delegation")<br/>      service_name = string<br/>      actions      = list(string)<br/>      }), {<br/>      enabled      = false<br/>      service_name = ""<br/>      actions      = []<br/>    })<br/>    attach_network_security_group = optional(bool, false)<br/>    network_security_group_id     = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to add to resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
<!-- END_TF_DOCS -->
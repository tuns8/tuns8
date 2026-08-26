<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-keyvault

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.42.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | (Required)String. Environment name. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Required)String. Project name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to apply to resources created by this module | `map(any)` | n/a | yes |
| <a name="input_allow_arm_secret_retrieval"></a> [allow\_arm\_secret\_retrieval](#input\_allow\_arm\_secret\_retrieval) | (Optional)Bool. Allow Azure Resource Manager to retrieve secrets from the key vault | `bool` | `"false"` | no |
| <a name="input_allow_azure_disk_encryption_secret_retrieval"></a> [allow\_azure\_disk\_encryption\_secret\_retrieval](#input\_allow\_azure\_disk\_encryption\_secret\_retrieval) | (Optional)Bool. Allow Azure Disk Encryption to retrieve secrets from the key vault | `bool` | `"false"` | no |
| <a name="input_allow_azure_vm_secret_retrieval"></a> [allow\_azure\_vm\_secret\_retrieval](#input\_allow\_azure\_vm\_secret\_retrieval) | (Optional)Bool. Allow Azure Virtual Machines to retrieve certificates stored as secrets from the key vault | `bool` | `"false"` | no |
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | (Optional)List. List of whitelisted IPs allowed to access the key vault. If restricting incoming traffic nacls\_default\_action should be set to 'Deny'. Defaults to the POISE network CIDR range | `list(string)` | <pre>[<br/>  "52.56.62.128/25"<br/>]</pre> | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | (Optional)String. Identifier for multiple project key vaults. | `string` | `null` | no |
| <a name="input_key_vault_soft_delete_retention_days"></a> [key\_vault\_soft\_delete\_retention\_days](#input\_key\_vault\_soft\_delete\_retention\_days) | Amount of days key vault will be soft deleted for | `number` | `7` | no |
| <a name="input_nacls_bypass"></a> [nacls\_bypass](#input\_nacls\_bypass) | (Optional)String. Which traffic can bypass the network rules. Possible values are 'AzureServices' and 'None'. Defaults to 'AzureServices'. | `string` | `"AzureServices"` | no |
| <a name="input_nacls_default_action"></a> [nacls\_default\_action](#input\_nacls\_default\_action) | (Optional)String. The Default Action to use when no rules match from nacls ip rules and nacls subnet rules. Possible values are 'Allow' and 'Deny'. Defaults to 'Deny'. In preprod/prod environments this is always 'Deny'. | `string` | `"Deny"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional)Bool. Public network access enabled. Defaults to true. | `bool` | `"true"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Optional)List. List of subnet IDs allowed to access the key vault. If restricting incoming traffic nacls\_default\_action should be set to 'Deny'. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_vault_name"></a> [vault\_name](#output\_vault\_name) | n/a |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | n/a |

## Tests

- There is 1 test case covered in this repo. See `tests/tests.tftest.hcl`
- To run tests locally run `terraform init` and then `terraform test` in the root directory

TODO: add more test details here
<!-- END_TF_DOCS -->
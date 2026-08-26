<!-- BEGIN_TF_DOCS -->
# Azure Storage Account Module
- This folder contains a module for implementing an Azure Storage Account. The module abstracts naming conventions and provides validation for resource arguments, ensuring that the storage account is configured correctly based on organizational standards.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.42.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [random_string.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | (Required) The replication type for the storage account. Options: LRS, GRS, RA-GRS, etc. | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | (Required) The tier of the storage account. Options: Standard, Premium. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) custom variable. This is the environment name where the storage account will be created. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Storage Account should exist. Changing this forces a new Storage Account to be created. | `string` | n/a | yes |
| <a name="input_main_project"></a> [main\_project](#input\_main\_project) | (Required) custom variable. main project name (lowercase letters and numbers only) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where the storage account will be created. | `string` | n/a | yes |
| <a name="input_sub_project"></a> [sub\_project](#input\_sub\_project) | (Required) custom variable. sub project name (lowercase letters and numbers only) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the Storage Account. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the storage account |
| <a name="output_name"></a> [name](#output\_name) | The name of the storage account |

 Test Cases

- There are 1 test cases covered in this repo. See `tests/tests.tftest.hcl`
- To run tests locally run `terraform init` and then `terraform test` in the root directory

TODO: add more test details here
<!-- END_TF_DOCS -->

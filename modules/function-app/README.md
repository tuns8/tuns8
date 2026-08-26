<!-- BEGIN_TF_DOCS -->
# Introduction
- Managing resources in Azure efficiently often requires using resource group with standardized naming conventions.
- This Terraform module helps in automating the creation of a function app.
- By using this module, you can ensure that your function app uses best practice across the automation centre.

# Azure Function App Module
- This is the terraform script to create a Function App with a set of pre-configured options.

Features:

- Function app (Windows or Linux) with Staging Slot and Virtual network integration by default
- Storage account created and configured if not provided. Storage account connection string stored in client provided key vault (key vault must allow network access from the same subnet as subnet input for this module)
- Optionally add application insights using a connection string and instrumentation key

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_linux_function_app_slot.function_app_slot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot) | resource |
| [azurerm_role_assignment.function_app_slot_vault_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.function_app_vault_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.fa_linux_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_service_plan.fa_windows_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_windows_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [azurerm_windows_function_app_slot.function_app_slot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app_slot) | resource |
| [random_integer.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [azurerm_role_definition.vault_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appName"></a> [appName](#input\_appName) | (Required) custom variable. App name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) custom variable. This is the environment name where the resource group will be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) custom variable. Resource Group Name | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) custom variable. Network subnet id | `string` | n/a | yes |
| <a name="input_application_insights_connection_string"></a> [application\_insights\_connection\_string](#input\_application\_insights\_connection\_string) | (Optional) Connection string for Application Insights | `string` | `null` | no |
| <a name="input_application_insights_instrumentation_key"></a> [application\_insights\_instrumentation\_key](#input\_application\_insights\_instrumentation\_key) | (Optional) Instrumentation Key for Connecting Application Insights to Function App | `string` | `null` | no |
| <a name="input_application_stack_dotnet_version"></a> [application\_stack\_dotnet\_version](#input\_application\_stack\_dotnet\_version) | (Optional) DotNet version. Possible values are; 3.1, 6.0, 7.0, 8.0 | `string` | `null` | no |
| <a name="input_application_stack_java_version"></a> [application\_stack\_java\_version](#input\_application\_stack\_java\_version) | (Optional) Java version. Possible values are; 8, 11, 17 | `string` | `null` | no |
| <a name="input_application_stack_node_version"></a> [application\_stack\_node\_version](#input\_application\_stack\_node\_version) | (Optional) Node version. Possible values are; 12, 14, 16, 18, 20 | `string` | `null` | no |
| <a name="input_application_stack_powershell_core_version"></a> [application\_stack\_powershell\_core\_version](#input\_application\_stack\_powershell\_core\_version) | (Optional) Powershell core version. Possibles values are 7 , 7.2, and 7.4. | `string` | `null` | no |
| <a name="input_application_stack_python_version"></a> [application\_stack\_python\_version](#input\_application\_stack\_python\_version) | (Optional) Python version, Only Supported with Linux Function Apps. Possible values are 3.12, 3.11, 3.10, 3.9, 3.8 and 3.7. | `string` | `null` | no |
| <a name="input_application_stack_use_dotnet_isolated_runtime"></a> [application\_stack\_use\_dotnet\_isolated\_runtime](#input\_application\_stack\_use\_dotnet\_isolated\_runtime) | (Optional) Should dotnet proccess use an isolated runtime? Defaults to False | `bool` | `false` | no |
| <a name="input_insights_app_type"></a> [insights\_app\_type](#input\_insights\_app\_type) | (Optional) Application Insights App type. Defaults to web | `string` | `"web"` | no |
| <a name="input_ip_restrictions"></a> [ip\_restrictions](#input\_ip\_restrictions) | (Optional) List of IP restrictions to apply to Function App | <pre>list(object({<br/>    action      = optional(string)<br/>    name        = optional(string)<br/>    ip_address  = optional(string)<br/>    priority    = optional(number)<br/>    service_tag = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "action": "Deny",<br/>    "ip_address": "0.0.0.0/0",<br/>    "name": "Default"<br/>  }<br/>]</pre> | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | (Optional) Key vault ID. Only Applicable if Storage account name is not set and will be used to store storage account connection key. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The Azure Region where the Function app should exist. changing this forces a new Resource Group to be created | `string` | `"uksouth"` | no |
| <a name="input_main_app_settings"></a> [main\_app\_settings](#input\_main\_app\_settings) | (Optional) Settings for the function app | `map(string)` | `{}` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | (Optional) OS Type for the function app | `string` | `"Linux"` | no |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | (Optional) Id of exiting service plan. Service plan generated if not set. | `string` | `null` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | (Optional) A mapping of site config options | `map(string)` | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU name for the app service plan | `string` | `"P1v3"` | no |
| <a name="input_staging_slot_settings"></a> [staging\_slot\_settings](#input\_staging\_slot\_settings) | (Optional) Settings for staging slot. If not used, main\_app\_settings will be applied | `map(string)` | `{}` | no |
| <a name="input_sticky_app_settings"></a> [sticky\_app\_settings](#input\_sticky\_app\_settings) | (Optional) List of App Settings that should not be swaped between slots | `list(string)` | `[]` | no |
| <a name="input_sticky_connection_strings"></a> [sticky\_connection\_strings](#input\_sticky\_connection\_strings) | (Optional) List of Connection strings that should not be swaped between slots | `list(string)` | `[]` | no |
| <a name="input_storage_access_key"></a> [storage\_access\_key](#input\_storage\_access\_key) | (Optional) Storage account access key if using an already generated resource | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | (Optional) Name of existing storage account. Storage account generate if not set. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the Resource Group | `map(string)` | `{}` | no |
| <a name="input_use_existing_service_plan"></a> [use\_existing\_service\_plan](#input\_use\_existing\_service\_plan) | (Optional) Flag used to set if the module should use an existing service plan. Defaults to false | `bool` | `false` | no |
| <a name="input_use_existing_storage_account"></a> [use\_existing\_storage\_account](#input\_use\_existing\_storage\_account) | (Optional) Flag used to set if the module should use an existing storage account. Defaults to false | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_app_default_hostname"></a> [function\_app\_default\_hostname](#output\_function\_app\_default\_hostname) | Default hostname of the functionApp |
| <a name="output_function_app_outbound_ip_addresses"></a> [function\_app\_outbound\_ip\_addresses](#output\_function\_app\_outbound\_ip\_addresses) | Outbound IP adresses of the functionApp |
| <a name="output_id"></a> [id](#output\_id) | The id of the functionApp |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the function app's managed identity. |
| <a name="output_identity_tenant_id"></a> [identity\_tenant\_id](#output\_identity\_tenant\_id) | Tenant ID of the function app's managed identity. |
| <a name="output_name"></a> [name](#output\_name) | The name of the functionApp |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | Generated service plan id |
| <a name="output_slot_id"></a> [slot\_id](#output\_slot\_id) | The id of the functionApps slot |
| <a name="output_staging_identity_principal_id"></a> [staging\_identity\_principal\_id](#output\_staging\_identity\_principal\_id) | Principal ID of the function app staging slot's managed identity. |
| <a name="output_staging_identity_tenant_id"></a> [staging\_identity\_tenant\_id](#output\_staging\_identity\_tenant\_id) | Tenant ID of the function app staging slot's managed identity. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Generated storage account name |
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
# Introduction
- Managing resources in Azure efficiently often requires using resource group with standardized naming conventions.
- This Terraform module helps in automating the creation of a logic app.
- By using this module, you can ensure that your logic app uses best practice across the automation centre.

# Azure Logic App Module
- This is the terraform script to create a Logic App with a set of pre-configured options.

Features:

- Logic app with Virtual network integration by default
- Storage account created and configured if not provided.
- Optionally add application insights using a connection string and instrumentation key

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.12.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.12.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_logic_app_standard.logic_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/logic_app_standard) | resource |
| [azurerm_service_plan.service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [random_integer.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_appName"></a> [appName](#input\_appName) | (Required) custom variable. App name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) custom variable. This is the environment name where the resource group will be created. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Required) project name. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) custom variable. Resource Group Name | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) custom variable. Network subnet id | `string` | n/a | yes |
| <a name="input_always_on"></a> [always\_on](#input\_always\_on) | (Optional) Should the Logic App be loaded at all times? Defaults to false | `bool` | `false` | no |
| <a name="input_app_insights_connection_string"></a> [app\_insights\_connection\_string](#input\_app\_insights\_connection\_string) | (Optional) Application insights connection string to connection logic app to applications insights. Connection string will be set in an app setting | `string` | `""` | no |
| <a name="input_app_insights_instrumentation_key"></a> [app\_insights\_instrumentation\_key](#input\_app\_insights\_instrumentation\_key) | (Optional) Application insights instrumentation key to connection logic app to applications insights. Instrumentation key will be set in an app setting | `string` | `""` | no |
| <a name="input_app_scale_limit"></a> [app\_scale\_limit](#input\_app\_scale\_limit) | (Optional) The number of workers this Logic App can scale out to. Only applicable to apps on the Consumption and Premium plan. | `number` | `null` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | (Optional) Settings for the logic app | `map(string)` | `{}` | no |
| <a name="input_client_affinity"></a> [client\_affinity](#input\_client\_affinity) | (Optional) Should the Logic App send session affinity cookies, which route client requests in the same session to the same instance? Defaults to false | `bool` | `false` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The mode of the Logic App's client certificates requirement for incoming requests. | `string` | `"Optional"` | no |
| <a name="input_dotnet_framework_version"></a> [dotnet\_framework\_version](#input\_dotnet\_framework\_version) | (Optional) The version of the .NET framework's CLR used in this Logic App. Defaults to v4.0 | `string` | `"v4.0"` | no |
| <a name="input_elastic_instance_minimum"></a> [elastic\_instance\_minimum](#input\_elastic\_instance\_minimum) | (Optional) The number of minimum instances for this Logic App Only affects apps on the Premium plan. | `number` | `null` | no |
| <a name="input_ftps_state"></a> [ftps\_state](#input\_ftps\_state) | (Optional) State of FTP / FTPS service for this Logic App. Possible values include: AllAllowed, FtpsOnly and Disabled. Defaults to AllAllowed. | `string` | `"AllAllowed"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | (Optional) Path which will be checked for this Logic App health. | `string` | `""` | no |
| <a name="input_http2_enabled"></a> [http2\_enabled](#input\_http2\_enabled) | Optional) Specifies whether the HTTP2 protocol should be enabled. Defaults to false | `bool` | `false` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | (Optional) Can the Logic App only be accessed via HTTPS? Defaults to false | `bool` | `false` | no |
| <a name="input_ip_restrictions"></a> [ip\_restrictions](#input\_ip\_restrictions) | (Optional) List of IP restrictions to apply to logic App | <pre>list(object({<br/>    action                    = optional(string)<br/>    name                      = optional(string)<br/>    ip_address                = optional(string)<br/>    priority                  = optional(number)<br/>    virtual_network_subnet_id = optional(string)<br/>    service_tag               = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "action": "Deny",<br/>    "ip_address": "0.0.0.0/0",<br/>    "name": "Default",<br/>    "priority": 65000<br/>  }<br/>]</pre> | no |
| <a name="input_linux_fx_version"></a> [linux\_fx\_version](#input\_linux\_fx\_version) | (Optional) Linux App Framework and version for the App Service. Only applicable if os\_type is set to Linux. Defaults to null | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The Azure Region where the logic app should exist. changing this forces a new Resource Group to be created | `string` | `"uksouth"` | no |
| <a name="input_pre_warmed_instance_count"></a> [pre\_warmed\_instance\_count](#input\_pre\_warmed\_instance\_count) | (Optional) The number of pre-warmed instances for this Logic App Only affects apps on the Premium plan. Defaults to null | `number` | `null` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | (Optional) Whether Public Network Access should be enabled or not. Defaults to false | `bool` | `true` | no |
| <a name="input_runtime_scale_monitoring_enabled"></a> [runtime\_scale\_monitoring\_enabled](#input\_runtime\_scale\_monitoring\_enabled) | (Optional) Should Runtime Scale Monitoring be enabled?. Only applicable to apps on the Premium plan. Defaults to false | `bool` | `false` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | (Optional) The runtime version associated with the logic app. Defaults to ~4 | `string` | `"~4"` | no |
| <a name="input_scm_ip_restrictions"></a> [scm\_ip\_restrictions](#input\_scm\_ip\_restrictions) | (Optional) List of SCM IP restrictions to apply to logic App | <pre>list(object({<br/>    action                    = optional(string)<br/>    name                      = optional(string)<br/>    ip_address                = optional(string)<br/>    priority                  = optional(number)<br/>    virtual_network_subnet_id = optional(string)<br/>    service_tag               = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "action": "Deny",<br/>    "ip_address": "0.0.0.0/0",<br/>    "name": "Default",<br/>    "priority": 65000<br/>  }<br/>]</pre> | no |
| <a name="input_scm_min_tls_version"></a> [scm\_min\_tls\_version](#input\_scm\_min\_tls\_version) | (Optional) Configures the minimum version of TLS required for SSL requests to the SCM site. Defaults to 1.2 | `number` | `1.2` | no |
| <a name="input_scm_type"></a> [scm\_type](#input\_scm\_type) | Optional) The type of Source Control used by the Logic App in use by the Windows Function App. Defaults to None | `string` | `"None"` | no |
| <a name="input_scm_use_main_ip_restriction"></a> [scm\_use\_main\_ip\_restriction](#input\_scm\_use\_main\_ip\_restriction) | (Optional) Should the Logic App ip\_restriction configuration be used for the SCM too. Defaults to false. | `bool` | `false` | no |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | (Optional) Id of exiting service plan. Service plan generated if not set. | `string` | `""` | no |
| <a name="input_service_plan_os"></a> [service\_plan\_os](#input\_service\_plan\_os) | (Optional) service plan operating system for the logic app. Defaults to Windows. Possible values are `Windows` or `Linux` | `string` | `"Windows"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU name for the app service plan. Defaults to WS1 | `string` | `"WS1"` | no |
| <a name="input_storage_access_key"></a> [storage\_access\_key](#input\_storage\_access\_key) | (Optional) Storage account access key if using an already generated resource | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | (Optional) Name of existing storage account. Storage account generate if not set. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the Resource Group | `map(string)` | `{}` | no |
| <a name="input_use_32_bit_worker_process"></a> [use\_32\_bit\_worker\_process](#input\_use\_32\_bit\_worker\_process) | (Optional) Should the Logic App run in 32 bit mode, rather than 64 bit mode? Defaults to true. When using app service plan in the Free or Shared Tiers use\_32\_bit\_worker\_process must be true | `bool` | `true` | no |
| <a name="input_use_existing_service_plan"></a> [use\_existing\_service\_plan](#input\_use\_existing\_service\_plan) | (Optional) Flag used to set if the module should use an existing service plan. Defaults to false | `bool` | `false` | no |
| <a name="input_use_existing_storage_account"></a> [use\_existing\_storage\_account](#input\_use\_existing\_storage\_account) | (Optional) Flag used to set if the module should use an existing storage account. Defaults to false | `bool` | `false` | no |
| <a name="input_vnet_route_all_enabled"></a> [vnet\_route\_all\_enabled](#input\_vnet\_route\_all\_enabled) | (Optional) Should all outbound traffic have Virtual Network Security Groups and User Defined Routes applied. | `bool` | `true` | no |
| <a name="input_websockets_enabled"></a> [websockets\_enabled](#input\_websockets\_enabled) | (Optional) Should WebSockets be enabled? Defaults to false | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the functionApp |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the logic app's managed identity. |
| <a name="output_identity_tenant_id"></a> [identity\_tenant\_id](#output\_identity\_tenant\_id) | Tenant ID of the logic app's managed identity. |
| <a name="output_logic_app_default_hostname"></a> [logic\_app\_default\_hostname](#output\_logic\_app\_default\_hostname) | Default hostname of the functionApp |
| <a name="output_logic_app_outbound_ip_addresses"></a> [logic\_app\_outbound\_ip\_addresses](#output\_logic\_app\_outbound\_ip\_addresses) | Outbound IP adresses of the functionApp |
| <a name="output_name"></a> [name](#output\_name) | The name of the functionApp |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | Generated service plan id |
| <a name="output_service_plan_name"></a> [service\_plan\_name](#output\_service\_plan\_name) | Generated service plan name |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | Generated storage account name |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Generated storage account name |
<!-- END_TF_DOCS -->
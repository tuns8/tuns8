variable "vnet_name" {
  type        = string
  description = "Name to give to the created vnet. Will be used in the pattern 'vnet-{var.vnet_name}-{var.environment}'."

  validation {
    condition     = can(regex("^[-\\w\\.]+$", var.vnet_name))
    error_message = "vnet_name must not contain characters disallowed in the Azure resource name."
  }
}

variable "environment_name" {
  type        = string
  default     = "dev"
  description = "Name of the environment being deployed, ie dev/test/preprod/live/etc."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy resources to."
}

variable "location" {
  type        = string
  default     = "UK South"
  description = "Location to deploy the resources. Should not be changed for HO resources unless needed."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to add to resource."
}

variable "vnet_address_prefixes" {
  type        = list(string)
  description = "Address space for the vnet. May include multiple address ranges however 1 should be suitable for most cases."

  validation {
    condition = (
      length(var.vnet_address_prefixes) > 0 &&
      length([for cidr in var.vnet_address_prefixes : cidr if can(cidrhost(cidr, 0))]) == length(var.vnet_address_prefixes)
    )
    error_message = "At least one CIDR must be supplied in for `vnet_address_prefixes` and all must be valid CIDR ranges."
  }
}

variable "subnets" {
  type = list(object({
    name                                          = string
    address_prefixes                              = list(string)
    default_outbound_access_enabled               = optional(bool)
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
    service_delegation = optional(object({
      enabled      = bool
      name         = optional(string, "delegation")
      service_name = string
      actions      = list(string)
      }), {
      enabled      = false
      service_name = ""
      actions      = []
    })
    attach_network_security_group = optional(bool, false)
    network_security_group_id     = optional(string)
  }))
  description = "Subnets to create in the vnet. Exposes all configuration fields available for `azurerm_subnet`, plus allowing declaration of an attached network security group."
  default     = []
}

variable "target_name" {
  type        = string
  description = "(Required) The name of the target of network security group. Nsg name will be constructed as '{target_name}-nsg'"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the network security group."
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "(Optional) The location where the network security group is created. Defaults to uk south"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags which should be assinged to the network security group."
}

variable "inbound_rules" {
  type = list(object({
    name                         = string
    priority                     = number
    access                       = string
    protocol                     = string
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    description                  = optional(string)
  }))
  default     = []
  description = "(Optional) List of inbound rule objects"
}

variable "outbound_rules" {
  type = list(object({
    name                         = string
    priority                     = number
    access                       = string
    protocol                     = string
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    description                  = optional(string)
  }))
  default     = []
  description = "(Optional) List of outbound rule objects"
}
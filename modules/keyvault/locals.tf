locals {
    identifier = var.identifier != null ? format("-%s", var.identifier) : "" #if an identifier is provided for a key vault, add "-" before it for naming
}
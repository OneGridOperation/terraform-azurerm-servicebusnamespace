locals {
  # Error: "name" cannot end with a hyphen, -sb, or -mgmt. Use `-sbns`.
  name     = var.override_name == null ? "${var.system_short_name}-${var.app_name}-${lower(var.environment)}-sbns" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  resource_group_name = var.resource_group.name
  name                = local.name
  location            = local.location
  sku                 = var.sku

  dynamic "identity" {
    for_each = try(var.identity, null) == null ? [] : [1]

    content {
      type         = var.identity.type
      identity_ids = length(regexall("UserAssigned", var.identity.type)) > 0 ? var.identity.identity_ids : null
    }
  }

  tags = var.tags
}

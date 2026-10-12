# One teleport_role per entry of var.roles.
resource "teleport_role" "this" {
  for_each = var.roles

  # Supported values: v3, v4, v5, v6, v7, v8
  version = each.value.version

  metadata = {
    name        = coalesce(each.value.name, each.key)
    description = each.value.description
    labels      = each.value.labels
  }

  spec = {
    allow = {
      logins           = each.value.allow.logins
      node_labels      = each.value.allow.node_labels
      app_labels       = each.value.allow.app_labels
      db_labels        = each.value.allow.db_labels
      kubernetes_users = each.value.allow.kubernetes_users
      rules            = each.value.allow.rules
    }

    deny = {
      logins      = each.value.deny.logins
      node_labels = each.value.deny.node_labels
    }

    options = each.value.options
  }
}

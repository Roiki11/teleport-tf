locals {
  # Role name for every managed role, keyed by the variable key. Used so
  # that users can refer to managed roles by their variable key even when
  # an explicit `name` overrides it.
  managed_role_names = { for key, role in var.roles : key => coalesce(role.name, key) }
}

# One teleport_user per entry of var.users.
resource "teleport_user" "this" {
  for_each = var.users

  # The only supported user resource version is v2.
  version = "v2"

  metadata = {
    name        = coalesce(each.value.name, each.key)
    description = each.value.description
    labels      = each.value.labels
  }

  spec = {
    # Each entry in `roles` is either a key of var.roles (resolved to the
    # managed role's name) or a literal Teleport role name such as the
    # built-in "access".
    roles = [for r in each.value.roles : try(local.managed_role_names[r], r)]

    traits = each.value.traits
  }

  # Do not try to destroy a role that is still assigned to a user.
  depends_on = [teleport_role.this]
}

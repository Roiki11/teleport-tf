# One teleport_bot (Machine ID bot) per entry of var.bots.
resource "teleport_bot" "this" {
  for_each = var.bots

  version = each.value.version

  scope = each.value.scope

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

  # Do not try to destroy a role that is still assigned to a bot.
  depends_on = [teleport_role.this]
}

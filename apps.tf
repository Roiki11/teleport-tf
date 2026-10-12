# One teleport_app per entry of var.apps.
resource "teleport_app" "this" {
  for_each = var.apps

  # The only supported app resource version is v3.
  version = each.value.version

  scope = each.value.scope

  metadata = {
    name        = coalesce(each.value.name, each.key)
    description = each.value.description
    labels      = each.value.labels
  }

  spec = {
    uri                  = each.value.uri
    public_addr          = each.value.public_addr
    insecure_skip_verify = each.value.insecure_skip_verify
    user_groups          = each.value.user_groups
    required_app_names   = each.value.required_app_names

    rewrite = {
      jwt_claims = each.value.rewrite.jwt_claims
      redirect   = each.value.rewrite.redirect
      headers    = each.value.rewrite.headers
    }

    tcp_ports      = each.value.tcp_ports
    tls            = each.value.tls
    dynamic_labels = each.value.dynamic_labels
  }
}

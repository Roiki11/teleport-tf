# One teleport_vnet_config per entry of var.vnet_configs. VNet configuration
# is cluster-wide; a single entry is normally sufficient.
resource "teleport_vnet_config" "this" {
  for_each = var.vnet_configs

  version = each.value.version

  metadata = {
    description = each.value.description
    labels      = each.value.labels
  }

  spec = {
    ipv4_cidr_range  = each.value.ipv4_cidr_range
    custom_dns_zones = each.value.custom_dns_zones
  }
}

# One teleport_database per entry of var.databases.
resource "teleport_database" "this" {
  for_each = var.databases

  # The only supported database resource version is v3.
  version = each.value.version

  metadata = {
    name        = coalesce(each.value.name, each.key)
    description = each.value.description
    labels      = each.value.labels
  }

  spec = {
    # Required. One of: cassandra, clickhouse, clickhouse-http, cockroachdb,
    # dynamodb, elasticsearch, mongodb, mysql, oracle, postgres, redis,
    # snowflake, spanner.
    protocol = each.value.protocol
    uri      = each.value.uri

    admin_user = {
      name             = each.value.admin_user.name
      default_database = each.value.admin_user.default_database
    }

    tls = {
      mode                   = each.value.tls.mode
      server_name            = each.value.tls.server_name
      ca_cert                = each.value.tls.ca_cert
      trust_system_cert_pool = each.value.tls.trust_system_cert_pool
    }

    mysql = {
      server_version = each.value.mysql.server_version
    }
  }
}

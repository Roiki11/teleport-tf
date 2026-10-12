# Teleport Terraform Project

Manages [Gravitational Teleport](https://goteleport.com/) resources — users and roles — with the official Teleport Terraform provider (`terraform.releases.teleport.dev/gravitational/teleport`).

## Project layout

| File | Purpose |
|------|---------|
| `versions.tf` | Required Terraform/provider versions |
| `providers.tf` | Teleport provider configuration |
| `variables.tf` | Input variables (connection settings + resource maps) |
| `roles.tf` | Creates one `teleport_role` per entry of `var.roles` |
| `users.tf` | Creates one `teleport_user` per entry of `var.users` |
| `apps.tf` | Creates one `teleport_app` per entry of `var.apps` |
| `databases.tf` | Creates one `teleport_database` per entry of `var.databases` |
| `vnets.tf` | Creates one `teleport_vnet_config` per entry of `var.vnet_configs` |
| `bots.tf` | Creates one `teleport_bot` (Machine ID) per entry of `var.bots` |
| `terraform.tfvars.example` | Example configuration — copy to `terraform.tfvars` |

> **Note on OpenTofu:** the Teleport provider is served from Teleport's own
> registry (`terraform.releases.teleport.dev`), which `tofu` cannot resolve
> directly. This project must be run with the `terraform` CLI (v1.3+), or with
> OpenTofu configured with a provider mirror that proxies the Teleport registry.

## Requirements

- Terraform >= 1.3
- A running Teleport cluster (Proxy or Auth service reachable from this machine)
- `tctl` access to the cluster to generate credentials for Terraform

## Authentication

The provider authenticates with a Teleport identity file. On a machine with
admin access to the cluster, run:

```bash
tctl auth sign --format=file --user=terraform --out=./terraform-identity --ttl=8760h
```

Everything can also be set through environment variables: `TF_TELEPORT_ADDR`,
`TF_TELEPORT_IDENTITY_FILE_PATH` (or `TF_TELEPORT_CERT`/`TF_TELEPORT_KEY`),
`TF_TELEPORT_INSECURE`. See the
[Teleport Terraform provider reference](https://goteleport.com/docs/reference/infrastructure-as-code/terraform-provider/)
for other options, including Machine ID join methods for CI/CD.

## Usage

1. Copy the example configuration and edit it:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Initialize and apply:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Adding resources

Resources are driven entirely by the maps in `terraform.tfvars` — add or remove
entries and re-run `terraform apply`.

```hcl
roles = {
  dev = {
    version = "v8"   # role versions: v3 .. v8 (defaults to v8)
    allow = {
      logins      = ["ubuntu"]
      node_labels = { env = ["dev"] }
    }
    options = {
      max_session_ttl = "12h"
    }
  }
}

users = {
  alice = {
    roles = ["dev"]   # key of the managed role, or a built-in name like "access"
    traits = {
      "github" = ["my-org"]
    }
  }
}

apps = {
  grafana = {
    uri         = "http://localhost:3000"
    public_addr = "grafana.example.com"
  }
}

databases = {
  prod-postgres = {
    protocol = "postgres"   # cassandra, clickhouse, cockroachdb, mongodb, mysql, redis, ...
    uri      = "postgres-prod.internal:5432"
    tls = {
      mode = 0             # 0 = verify-full, 1 = verify-ca, 2 = insecure
    }
  }
}

vnet_configs = {
  default = {
    ipv4_cidr_range  = "100.64.0.0/10"
    custom_dns_zones = [{ suffix = "internal.example.com" }]
  }
}

bots = {
  ci-deployer = {
    roles = ["dev"]
  }
}
```

Role references in a user's or bot's `roles` list may be either a key of
`var.roles` (resolved to that role's name) or any literal Teleport role name,
including built-ins such as `access`, `editor`, and `auditor`.

Resource versions: `teleport_app` and `teleport_database` require `v3` (set by
default); `teleport_vnet_config` and `teleport_bot` use `v1` (set by default).

## Provider versions

The provider version should match your Teleport cluster's client tools version
(`curl https://<your-teleport-domain>/webapi/ping | jq -r '.auto_update.tools_version'`).
Pin it in `versions.tf` accordingly.

## State

State is stored locally (`terraform.tfstate`), which is git-ignored. For team
use, configure a [remote backend](https://developer.hashicorp.com/terraform/language/state/remote)
in `versions.tf` before running `terraform init`.

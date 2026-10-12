variable "teleport_addr" {
  description = "Address of the Teleport Proxy or Auth service (host:port), e.g. teleport.example.com:3080. Can also be set with the TF_TELEPORT_ADDR environment variable."
  type        = string
}

variable "teleport_identity_file" {
  description = "Path to a Teleport identity file created with `tctl auth sign --format=file`. Leave as null to configure the provider with the TF_TELEPORT_IDENTITY_FILE_PATH environment variable or a `tsh` profile."
  type        = string
  default     = null
  sensitive   = true
}

variable "teleport_insecure" {
  description = "Skip TLS verification of the Teleport endpoint (testing only)."
  type        = bool
  default     = false
}

variable "roles" {
  description = "Map of Teleport roles to manage. The map key is used as the role name unless `name` is set explicitly."
  type = map(object({
    name        = optional(string)
    description = optional(string, "Managed by Terraform")
    labels      = optional(map(string), {})
    version     = optional(string, "v8")

    allow = optional(object({
      logins           = optional(list(string), [])
      node_labels      = optional(map(list(string)), {})
      app_labels       = optional(map(list(string)), {})
      db_labels        = optional(map(list(string)), {})
      kubernetes_users = optional(list(string), [])
      rules = optional(list(object({
        resources = optional(list(string), [])
        verbs     = optional(list(string), [])
        where     = optional(string)
        actions   = optional(list(string), [])
      })), [])
    }), {})

    deny = optional(object({
      logins      = optional(list(string), [])
      node_labels = optional(map(list(string)), {})
    }), {})

    options = optional(object({
      max_session_ttl     = optional(string)
      client_idle_timeout = optional(string)
      forward_agent       = optional(bool)
      port_forwarding     = optional(bool)
    }), {})
  }))
  default = {}
}

variable "users" {
  description = "Map of Teleport users to manage. The map key is used as the username unless `name` is set explicitly. Role references may be keys of `roles` above or literal Teleport role names."
  type = map(object({
    name        = optional(string)
    description = optional(string, "Managed by Terraform")
    roles       = optional(list(string), [])
    traits      = optional(map(list(string)), {})
    labels      = optional(map(string), {})
  }))
  default = {}
}

variable "apps" {
  description = "Map of Teleport applications to manage. The map key is used as the app name unless `name` is set explicitly."
  type = map(object({
    name        = optional(string)
    description = optional(string, "Managed by Terraform")
    labels      = optional(map(string), {})
    version     = optional(string, "v3")
    scope       = optional(string)

    uri                  = optional(string)
    public_addr          = optional(string)
    insecure_skip_verify = optional(bool)
    user_groups          = optional(list(string), [])
    required_app_names   = optional(list(string), [])

    rewrite = optional(object({
      jwt_claims = optional(string)
      redirect   = optional(list(string), [])
      headers = optional(list(object({
        name  = string
        value = string
      })), [])
    }), {})

    tcp_ports = optional(list(object({
      port     = optional(number)
      end_port = optional(number)
    })), [])

    tls = optional(object({
      mode        = optional(string)
      server_name = optional(string)
    }), {})

    dynamic_labels = optional(map(object({
      command = optional(list(string), [])
      period  = optional(string)
      result  = optional(string)
    })), {})
  }))
  default = {}
}

variable "databases" {
  description = "Map of Teleport databases to manage. The map key is used as the database name unless `name` is set explicitly."
  type = map(object({
    name        = optional(string)
    description = optional(string, "Managed by Terraform")
    labels      = optional(map(string), {})
    version     = optional(string, "v3")

    protocol = string
    uri      = string

    admin_user = optional(object({
      name             = optional(string)
      default_database = optional(string)
    }), {})

    tls = optional(object({
      mode                   = optional(number)
      server_name            = optional(string)
      ca_cert                = optional(string)
      trust_system_cert_pool = optional(bool)
    }), {})

    mysql = optional(object({
      server_version = optional(string)
    }), {})
  }))
  default = {}
}

variable "vnet_configs" {
  description = "Map of Teleport VNet configurations to manage. A cluster normally needs only one entry."
  type = map(object({
    description     = optional(string, "Managed by Terraform")
    labels          = optional(map(string), {})
    version         = optional(string, "v1")
    ipv4_cidr_range = optional(string)
    custom_dns_zones = optional(list(object({
      suffix = string
    })), [])
  }))
  default = {}
}

variable "bots" {
  description = "Map of Teleport Machine ID bots to manage. The map key is used as the bot name unless `name` is set explicitly. Role references may be keys of `roles` or literal Teleport role names."
  type = map(object({
    name        = optional(string)
    description = optional(string, "Managed by Terraform")
    labels      = optional(map(string), {})
    version     = optional(string, "v1")
    scope       = optional(string)
    roles       = optional(list(string), [])
    traits      = optional(map(list(string)), {})
  }))
  default = {}
}
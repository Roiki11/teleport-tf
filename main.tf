terraform {
  required_providers {
    teleport = {
      source  = "gravitational/teleport"
      version = "~> 0.5"
    }
  }
}

provider "teleport" {
  # Configuration options for the Teleport provider
  # These can also be set via environment variables:
  # TELEPORT_ENDPOINT, TELEPORT_TOKEN, TELEPORT_INSECURE
  endpoint = var.teleport_endpoint
  token    = var.teleport_token
}

resource "teleport_role" "admin" {
# Example Teleport Role
  metadata {
    name = "admin-role"
  }

  spec {
    allow {
      logins = ["root", "admin"]
      node_labels = {
        "env" = "*"
      }
      # Additional allow rules can be added here
    }

    deny {
      # Example deny rules
    }

    options {
      max_session_ttl = "24h"
      idle_timeout    = "15m"
    }
  }
}

# Example Teleport User
resource "teleport_user" "admin_user" {
  metadata {
    name = "admin-user"
  }

  spec {
    roles = [teleport_role.admin.metadata[0].name]
    # Alternatively, you can specify roles directly: roles = ["admin-role"]
    # You can also add other user properties like:
    #   logins = ["admin"]
    #   traits = { ... }
  }
}



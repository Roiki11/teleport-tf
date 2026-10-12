terraform {
  required_version = ">= 1.3"

  required_providers {
    teleport = {
      # The Teleport provider is distributed through Teleport's own
      # provider registry, not registry.terraform.io.
      # See: https://goteleport.com/docs/reference/infrastructure-as-code/terraform-provider/
      source  = "terraform.releases.teleport.dev/gravitational/teleport"
      version = ">= 16.0.0"
    }
  }
}

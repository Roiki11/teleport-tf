provider "teleport" {
  # Address of the Teleport Proxy/Auth service (host:port).
  # Can also be set with the TF_TELEPORT_ADDR environment variable.
  addr = var.teleport_addr

  # Path to an identity file created with:
  #   tctl auth sign --format=file --user=terraform --out=./terraform-identity --ttl=8760h
  # Leave as null to authenticate via TF_TELEPORT_IDENTITY_FILE_PATH /
  # TF_TELEPORT_CERT / TF_TELEPORT_KEY environment variables, or via
  # Machine ID join methods (join_method) or a `tsh` profile.
  identity_file_path = var.teleport_identity_file

  # Skip TLS verification of the Teleport endpoint. Testing only.
  insecure = var.teleport_insecure
}


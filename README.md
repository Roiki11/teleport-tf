# OpenTofu Teleport Provider Example

This example demonstrates how to use the [Teleport OpenTofu provider](https://registry.terraform.io/providers/gravitational/teleport/latest) to configure Teleport users and roles.

## Requirements

- [OpenTofu](https://opentofu.org/) (>= 1.0) or Terraform (>= 0.13)
- Teleport Auth Service running and accessible
- A Teleport token with sufficient privileges to create users and roles

## Usage

1. Copy the example files to your working directory.

2. Initialize the OpenTofu provider:
   ```bash
   tofu init
   ```

3. Create a `terraform.tfvars` file to set your Teleport connection details:
   ```hcl
   teleport_endpoint = "https://your-teleport-instance.example.com:3080"
   teleport_token    = "your-teleport-token"
   ```

   Alternatively, you can set the environment variables:
   - `TELEPORT_ENDPOINT`
   - `TELEPORT_TOKEN`

4. Review the resources in `main.tf` and adjust as needed for your environment.

5. Apply the configuration:
   ```bash
   tofu apply
   ```

## Resources

- `teleport_role.admin`: Defines a role with administrative privileges.
- `teleport_user.admin_user`: Creates a user assigned to the admin role.

## Customization

Modify the `spec` blocks in the resources to adjust:
- Allowed logins
- Node labels
- Session settings
- Additional traits for users
- Role permissions

## References

- [Teleport OpenTofu/Terraform Provider Documentation](https://registry.terraform.io/providers/gravitational/teleport/latest)
- [Teleport Role Resource](https://registry.terraform.io/providers/gravitational/teleport/latest/docs/resources/role)
- [Teleport User Resource](https://registry.terraform.io/providers/gravitational/teleport/latest/docs/resources/user)

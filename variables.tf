variable "teleport_endpoint" {
  description = "Teleport Auth Service endpoint (e.g., https://teleport.example.com:3080)"
  type        = string
}

variable "teleport_token" {
  description = "Teleport token for authentication"
  type        = string
  sensitive   = true
}

variable "users" {
  description = "Map of user configurations"
  type        = map(object({
    name        = string
    roles       = list(string)
    logins      = list(string)
    traits      = map(string)
  }))
}

variable "roles" {
  description = "Map of role configurations"
  type        = map(object({
    name        = string
    allow       = object({
      logins        = list(string)
      node_labels   = map(string)
    })
    deny        = object({
      # Example: you can define specific deny rules here if needed
      # For flexibility, we leave it as a map of string to any
    })
    options     = object({
      max_session_ttl = string
      idle_timeout    = string
    })
  }))
}

variable "dynamic_apps" {
  description = "Map of dynamic application configurations"
  type        = map(any)
}

variable "database_configs" {
  description = "Map of database configuration maps"
  type        = map(object({
    host     = string
    port     = number
    name     = string
    username = string
    password = string
  }))
}
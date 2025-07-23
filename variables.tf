variable "project_id" {
  type        = string
  description = "Scaleway project ID."
}

variable "organization_id" {
  type        = string
  description = "Scaleway organization ID."
}

variable "public_ssh_key" {
  type        = string
  description = "Public SSH key to be used for authentication."
}

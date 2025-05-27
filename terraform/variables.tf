# Define a variable for the Hetzner Cloud API token
variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "Hetzner Cloud API Token"
}
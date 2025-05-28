# Define a variable for the Hetzner Cloud API token
variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "Hetzner Cloud API Token"
}

variable "k8s_network_id" {
  type        = string
  description = "The ID of the Kubernetes network in Hetzner Cloud"

}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for accessing the Hetzner k8s nodes"
}


variable "worker_ssh_public_key" {
  type        = string
  description = "Public SSH key for accessing the Hetzner k8s nodes"
}
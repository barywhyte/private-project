variable "labels" {
  type = map(string)
  default = {
    managed = "Terraform"
    project     = "special-project"
  }
}

variable "k8s_network_id" {
  type        = string
  description = "The ID of the Kubernetes network in Hetzner Cloud"

}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for accessing the Hetzner k8s nodes"
}

#variable "worker_ssh_public_key" {
#  type        = string
#  description = "Public SSH key for accessing the Hetzner k8s nodes"
#}
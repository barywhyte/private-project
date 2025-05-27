# This Terraform configuration sets up the Hetzner Cloud provider
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# ssh key for accessing the Hetzner k8s nodes
resource "hcloud_ssh_key" "main" {
  name       = "k8s-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}


module "k8s_network" {
  source = "./modules/networks"

}
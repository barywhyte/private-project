# This Terraform configuration sets up the Hetzner Cloud provider
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.51.0"
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

module "kubernetes" {
  source = "./modules/kubernetes"

  k8s_network_id = module.k8s_network.network_id
  ssh_public_key = var.ssh_public_key
  #worker_ssh_public_key = var.worker_ssh_public_key
  depends_on = [module.k8s_network]

}
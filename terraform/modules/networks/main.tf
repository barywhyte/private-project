terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}


resource "hcloud_network" "k8s_network" {
  name     = "kubernetes-network"
  ip_range = "10.0.0.0/16"

  labels = var.labels
}

resource "hcloud_network_subnet" "k8s_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.k8s_network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"

}


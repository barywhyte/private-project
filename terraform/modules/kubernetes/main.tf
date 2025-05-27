
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.51.0"
    }
  }
}

# Create kubernetes master node
resource "hcloud_server" "master_node" {
  name        = "master-node"
  image       = "ubuntu-24.04"

  server_type = "cax11"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = var.k8s_network_id

    ip         = "10.0.1.1"
  }
  user_data = file("${path.module}/master-cloud-init.yaml")
  labels = var.labels
}



# Create kubernetes worker node
resource "hcloud_server" "worker_nodes" {
  count = 2
  name        = "worker-node-${count.index}"
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = var.k8s_network_id
  }
  user_data = file("${path.module}/worker-cloud-init.yaml")

  depends_on = [hcloud_server.master_node]
}
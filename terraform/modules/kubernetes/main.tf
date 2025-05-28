
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
  public_key = file("~/.ssh/id_ed25519.pub")
}

# Create kubernetes master node
resource "hcloud_server" "master_node" {
  name        = "master-node"
  image       = "ubuntu-24.04"
  ssh_keys    = [hcloud_ssh_key.main.id]
  server_type = "cax11"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  network {
    network_id = var.k8s_network_id

    ip = "10.0.1.1"
  }
  user_data  = file("${path.module}/master-cloud-init.yaml")
  labels     = var.labels
  depends_on = [hcloud_ssh_key.main]
}



# Create kubernetes worker node
resource "hcloud_server" "worker_nodes" {
  count       = 2
  name        = "worker-node-${count.index}"
  image       = "ubuntu-24.04"
  ssh_keys    = [hcloud_ssh_key.main.id]
  server_type = "cax11"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  network {
    network_id = var.k8s_network_id
    ip         = element(["10.0.1.3", "10.0.1.2"], count.index) # This is not idea but it stop terraform drift during plan and apply. Will fix later
  }
  user_data = file("${path.module}/worker-cloud-init.yaml")
  labels    = var.labels

  depends_on = [hcloud_server.master_node, hcloud_ssh_key.main]
  #lifecycle {
  #  ignore_changes = [network[0].ip]
  #}
}
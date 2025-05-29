
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.51.0"
    }
  }
}

locals {
  master_cloud_init = templatefile("${path.module}/master-cloud-init.yaml", {
    ssh_public_key        = file("~/.ssh/id_ed25519.pub")
    worker_ssh_public_key = file("~/.ssh/id_ed25519_worker.pub")
  })
  worker_cloud_init = templatefile("${path.module}/worker-cloud-init.yaml", {
    ssh_public_key  = file("~/.ssh/id_ed25519_worker.pub")
    ssh_private_key = file("~/.ssh/id_ed25519_worker")
  })
}


# ssh key for accessing the Hetzner k8s nodes
resource "hcloud_ssh_key" "master" {
  name       = "master-ssh-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_ssh_key" "worker" {
  name       = "worker-ssh-key"
  public_key = file("~/.ssh/id_ed25519_worker.pub")
}

# Create kubernetes master node
resource "hcloud_server" "master_node" {
  name        = "master-node"
  image       = "ubuntu-24.04"
  ssh_keys    = [hcloud_ssh_key.master.id]
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
  user_data  = local.master_cloud_init
  labels     = var.labels
  depends_on = [hcloud_ssh_key.master]
}

# Create kubernetes worker node
resource "hcloud_server" "worker_nodes" {
  count       = 2
  name        = "worker-node-${count.index}"
  image       = "ubuntu-24.04"
  ssh_keys    = [hcloud_ssh_key.worker.id]
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
  user_data = local.worker_cloud_init
  labels    = var.labels

  depends_on = [hcloud_server.master_node, hcloud_ssh_key.worker]
  #lifecycle {
  #  ignore_changes = [network[0].ip]
  #}
}
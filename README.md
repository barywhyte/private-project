# k3s Kubernetes Cluster Deployment with Terraform and Cloud-Init

## Project Description

This project automates the provisioning of a lightweight Kubernetes cluster using **k3s** on a set of virtual machines. The cluster consists of one master node and multiple worker nodes that automatically join the master on boot via **cloud-init** scripts.

The provisioning leverages **Terraform** to create and configure infrastructure components such as networking, virtual machines, and node initialization with cloud-init. This approach aims to create a reproducible and automated k3s cluster deployment, suitable for development or small production environments.

---

## Directory Structure

```
├── README.md
└── terraform
    ├── main.tf
    ├── modules
    │   ├── kubernetes
    │   │   ├── main.tf
    │   │   ├── master-cloud-init.yaml
    │   │   ├── variables.tf
    │   │   └── worker-cloud-init.yaml
    │   └── networks
    │       ├── main.tf
    │       ├── output.tf
    │       └── variables.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── terraform.tfvars
    ├── variables.tf
```


---

## Deployment Process

1. **Prepare Terraform environment and kubectl command**
   - Install Terraform CLI on your machine.
   - Install kubectl CLI on your machine
   - Configure your cloud provider credentials (Hetzner API Token).

2. **Customize variables**
   - Edit `terraform/terraform.tfvars` to match your environment and preferences. Not checked into github
   - Replace SSH public key placeholders in cloud-init files with your actual public keys.

3. **Initialize and deploy Terraform**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply


# Join worker node to the master, control plan node
## Manual intervention

This repository contains a **worker-cloud-init.yaml** configuration to automatically boostrap worker nodes and join them to an existing k3s master node, forming a lightweight Kubernetes cluster.

## After successful Terraform deployment
```
- ssh  worker@worker-node-public-IP
- sudo echo "WORKER NODE PRIVATE SSH KEY" >> ~/.ssh/id_ed25519 or just open with vi editor and paste shh key
- MASTER_TOKEN=$(ssh -o StrictHostKeyChecking=accept-new master@10.0.1.1 sudo cat /var/lib/rancher/k3s/server/node-token)
- curl -sfL https://get.k3s.io | K3S_URL=https://10.0.1.1:6443 K3S_TOKEN=$MASTER_TOKEN INSTALL_K3S_EXEC="--kubelet-arg cloud-provider=external" sh -
- exit
```

### Repeat same process for the second worker node etc

## On your local machine. Make sure to retrive master IP address from heztner console
```
- mkdir -p $HOME/.kube
- scp -i ~/.ssh/id_ed25519 master@MASTER-NODE-PUBLIC-IP:/etc/rancher/k3s/k3s.yaml ~/.kube/config
- sed -i 's|https://127.0.0.1:6443|https://MASTER-NODE-PUBLIC-IP:6443|g' ~/.kube/config
- kubectl get nodes
```

## Example output
```
NAME            STATUS   ROLES                  AGE   VERSION
master-node     Ready    control-plane,master   86m   v1.32.5+k3s1
worker-node-0   Ready    <none>                 62m   v1.32.5+k3s1
worker-node-1   Ready    <none>                 68m   v1.32.5+k3s1
```

---

- **SSH Key Not Created / Permission Issues**
  If the private key file `/home/worker/.ssh/id_ed25519` is missing or incorrect, the worker node will fail to SSH into the master to retrieve the token. This prevents automatic cluster joining.

  **Workaround:**
  Manually SSH into the worker node and place the private key with correct ownership and permissions:

  ```bash
  sudo -u worker mkdir -p /home/worker/.ssh
  sudo tee /home/worker/.ssh/id_ed25519 > /dev/null << 'EOF'
  -----BEGIN OPENSSH PRIVATE KEY-----
  <your private key base64-decoded here>
  -----END OPENSSH PRIVATE KEY-----
  EOF
  sudo chown worker:worker /home/worker/.ssh/id_ed25519
  sudo chmod 600 /home/worker/.ssh/id_ed25519


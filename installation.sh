#!/bin/bash
set -e

echo "======================================"
echo " 🔹 Updating System Packages"
echo "======================================"
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y curl unzip tar apt-transport-https ca-certificates gnupg software-properties-common

# ------------------------------------------------------------------------
# Install Docker
# ------------------------------------------------------------------------
echo "======================================"
echo " 🔹 Installing Docker"
echo "======================================"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER || true
sudo systemctl enable docker
sudo systemctl start docker

# ------------------------------------------------------------------------
# Install Terraform
# ------------------------------------------------------------------------
echo "======================================"
echo " 🔹 Installing Terraform"
echo "======================================"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y
sudo apt install -y terraform

# ------------------------------------------------------------------------
# Install kubectl
# ------------------------------------------------------------------------
echo "======================================"
echo " 🔹 Installing kubectl"
echo "======================================"
KUBECTL_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# ------------------------------------------------------------------------
# Install eksctl
# ------------------------------------------------------------------------
echo "======================================"
echo " 🔹 Installing eksctl"
echo "======================================"
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"
tar -xvzf eksctl_$(uname -s)_amd64.tar.gz
sudo mv eksctl /usr/local/bin/

# ------------------------------------------------------------------------
# Verify Installations
# ------------------------------------------------------------------------
echo "======================================"
echo " ✅ Versions Installed"
echo "======================================"
docker --version
terraform -version
kubectl version --client --output=yaml
eksctl version

echo "🎉 Installation complete! Please log out and log back in (or run 'newgrp docker') to use Docker without sudo."


#TODO: Use this from a single point, like terraform/versions.tf
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.28.0"
    }
  }
}

# Configure Kubernetes provider and connect to the Kubernetes API server
resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    #TODO: Use region and name from previos created cluster
    command = "aws eks --region us-west-1 update-kubeconfig --name magoya-testing"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

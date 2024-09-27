terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.28.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
provider "aws" {
  region = "us-west-1"
}

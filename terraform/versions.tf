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
  backend "s3" {
    bucket  = var.s3bucket_state
    key     = "./terraform.tfstate"
    region  = "us-west-1"
    encrypt = true
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "aws" {
  region = "us-west-1"
}

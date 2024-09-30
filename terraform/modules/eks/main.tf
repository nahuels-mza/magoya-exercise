module "iam" {
  source = "../iam"
}
module "vpc" {
  source = "../vpc"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = module.iam.eks_iam_role_app_node_arn
  version  = "1.30"

  vpc_config {
    subnet_ids = ["${module.vpc.private_subnet_id[0]}", "${module.vpc.private_subnet_id[1]}"]
  }
  # cluster_endpoint_public_access = true

  depends_on = [
    module.iam
  ]
}
resource "aws_eks_node_group" "system-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "system"
  node_role_arn   = module.iam.eks_iam_role_system_node_arn
  subnet_ids      = ["${module.vpc.private_subnet_id[0]}", "${module.vpc.private_subnet_id[1]}"]
  instance_types  = [var.instance_type]

  capacity_type = "ON_DEMAND"
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  depends_on = [aws_eks_cluster.eks_cluster, module.iam]
  labels = {
    role = "sytem"
  }
}

resource "aws_eks_node_group" "app-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "application"
  node_role_arn   = module.iam.eks_iam_role_app_node_arn
  subnet_ids = [
    "${module.vpc.public_subnet_id[0]}",
    "${module.vpc.public_subnet_id[1]}",
    "${module.vpc.private_subnet_id[0]}",
    "${module.vpc.private_subnet_id[1]}"
  ]
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  depends_on = [aws_eks_cluster.eks_cluster, module.iam]
  labels = {
    role = "app"
  }
}

#aws eks --region us-east-2 update-kubeconfig --name

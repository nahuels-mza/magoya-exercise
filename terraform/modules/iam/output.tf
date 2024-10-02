output "eks_iam_role_system_node_arn" {
  value = aws_iam_role.system-node-role.arn
}

output "eks_iam_role_system_node_policy" {
  value = aws_iam_role.system-node-role.assume_role_policy
}

output "eks_iam_role_app_node_arn" {
  value = aws_iam_role.app-npde-role.arn
}

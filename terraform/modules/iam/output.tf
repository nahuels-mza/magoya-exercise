output "eks_iam_role_cluster_arn" {
  value = aws_iam_role.cluster_role.arn

}
output "eks_iam_role_cluster_policy" {
  value = aws_iam_role.cluster_role.assume_role_policy
}

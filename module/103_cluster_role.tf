resource "aws_iam_role" "cluster" {
  name               = "${local.lower_name}_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
  //  permissions_boundary  = var.permissions_boundary
  //  path                  = var.iam_path
  force_detach_policies = true
  tags = merge(
    {
      "Name" = "${local.lower_name}_eks_cluster_role"
    },
    local.tags,
  )
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}
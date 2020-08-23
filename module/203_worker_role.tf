resource "aws_iam_role" "workers" {
  name               = "${local.lower_name}_eks_worker_role"
  assume_role_policy = data.aws_iam_policy_document.workers_assume_role_policy.json
  //  permissions_boundary  = var.permissions_boundary
  //  path                  = var.iam_path
  force_detach_policies = true
  tags = merge(
    {
      "Name" = "${local.lower_name}_eks_worker_role"
    },
    local.tags,
  )
}

resource "aws_iam_instance_profile" "workers" {
  name = "${local.lower_name}_worker_profile"
  role = aws_iam_role.workers.name
  //  path = var.iam_path
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}
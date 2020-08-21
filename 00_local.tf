locals {
  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}


locals {
  upper_name = upper(var.cluster_name)
  lower_name = lower(var.cluster_name)
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  tags = merge(
    {
      "KubernetesCluster"                         = local.lower_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    var.common_tags,
  )
}
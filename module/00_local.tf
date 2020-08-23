locals {
  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  kubeconfig_name = var.kubeconfig_name == "" ? "eks_${var.cluster_name}" : var.kubeconfig_name

  kubeconfig = templatefile("${path.module}/templates/kubeconfig.tpl", {
    kubeconfig_name                   = local.kubeconfig_name
    endpoint                          = aws_eks_cluster.this.endpoint
    cluster_auth_base64               = aws_eks_cluster.this.certificate_authority[0].data
    aws_authenticator_command         = var.kubeconfig_aws_authenticator_command
    aws_authenticator_command_args    = ["token", "-i", aws_eks_cluster.this.name]
    aws_authenticator_additional_args = var.kubeconfig_aws_authenticator_additional_args
    aws_authenticator_env_variables   = var.kubeconfig_aws_authenticator_env_variables
  })
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
resource "aws_eks_cluster" "this" {
  //  count                     = var.create_eks ? 1 : 0
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.cluster_version
  tags                      = local.tags
  enabled_cluster_log_types = var.cluster_enabled_log_types

  vpc_config {
    security_group_ids      = [aws_security_group.cluster.id]
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
  }

  //  dynamic encryption_config {
  //    for_each = toset(var.cluster_encryption_config)
  //    content {
  //      provider {
  //        key_arn = encryption_config.value["provider_key_arn"]
  //      }
  //      resources = encryption_config.value["resources"]
  //    }
  //  }

  depends_on = [
    aws_security_group_rule.cluster_egress_internet,
    aws_security_group_rule.cluster_https_worker_ingress,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.this
  ]
}
resource "aws_eks_node_group" "workers" {
  for_each = local.node_groups_expanded

  node_group_name = lookup(each.value, "name", join("-", [var.cluster_name, each.key]))

  cluster_name  = var.cluster_name
  node_role_arn = each.value["iam_role_arn"]
  subnet_ids    = each.value["subnets"]

  scaling_config {
    desired_size = each.value["desired_capacity"]
    max_size     = each.value["max_capacity"]
    min_size     = each.value["min_capacity"]
  }

  ami_type        = lookup(each.value, "ami_type", null)
  disk_size       = lookup(each.value, "disk_size", null)
  instance_types  = [each.value["instance_type"]]
  release_version = lookup(each.value, "ami_release_version", null)

  dynamic "remote_access" {
    for_each = each.value["key_name"] != "" ? [{
      ec2_ssh_key               = each.value["key_name"]
      source_security_group_ids = lookup(each.value, "source_security_group_ids", [])
    }] : []

    content {
      ec2_ssh_key               = remote_access.value["ec2_ssh_key"]
      source_security_group_ids = concat(remote_access.value["source_security_group_ids"], [aws_security_group.workers.id])
    }
  }

  version = lookup(each.value, "version", null)

  labels = merge(
    lookup(var.node_groups_defaults, "k8s_labels", {}),
    lookup(var.node_groups[each.key], "k8s_labels", {})
  )

  tags = merge(
    local.tags,
    lookup(var.node_groups_defaults, "additional_tags", {}),
    lookup(var.node_groups[each.key], "additional_tags", {}),
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

  depends_on = [
    aws_eks_cluster.this,
    kubernetes_config_map.aws_auth,
    aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly
  ]
}

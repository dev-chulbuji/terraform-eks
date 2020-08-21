resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
  kms_key_id        = var.cluster_log_kms_key_id
  tags = merge(
    {
      "Name" = local.lower_name
    },
    local.tags,
  )
}
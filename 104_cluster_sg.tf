# cluster security group
resource "aws_security_group" "cluster" {
  name   = "${local.lower_name}_eks_cluster_sg"
  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name" = "${local.lower_name}_eks_cluster_sg"
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  description              = "Allow node to communicate with the cluster API Server"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.workers.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}
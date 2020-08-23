module "eks" {
  source          = "./module"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    dj = {
      name             = "dj_node_group"
      desired_capacity = 3
      max_capacity     = 10
      min_capacity     = 1

      key_name = "dj"

      instance_type = "t3.large"

      k8s_labels = {
        Environment = "test"
      }

      additional_tags = {
        test = "dj"
      }
    }
  }

  map_roles = []
  map_users = []

  common_tags = {
    "TerraformManaged" = "true"
    "test"             = "dj"
  }
}

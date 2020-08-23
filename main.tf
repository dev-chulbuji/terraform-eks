module "eks" {
  source          = "./module"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    dj = {
      name             = "dj_node_group"
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_type = "m5.large"
      k8s_labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      additional_tags = {
        ExtraTag = "example"
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

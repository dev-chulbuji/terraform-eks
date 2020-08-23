terraform {
  backend "s3" {
    bucket = "dj-tf-backend-dev"
    key    = "eks/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  version = ">= 3.3.0"
  region  = "ap-northeast-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}
locals {
  # Convert to format needed by aws-auth ConfigMap
  configmap_roles = [
    for role in concat(local.worker_roles) :
    {
      # Work around https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/153
      # Strip the leading slash off so that Terraform doesn't think it's a regex
      rolearn  = replace(role["worker_role_arn"], replace("/", "/^//", ""), "")
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = tolist(concat(
        [
          "system:bootstrappers",
          "system:nodes",
        ],
        [
          "eks:kube-proxy-windows"
        ]
      ))
    }
  ]
}

resource "kubernetes_config_map" "aws_auth" {
  //  depends_on = [null_resource.wait_for_cluster[0]]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.configmap_roles,
        var.map_roles,
      ))
    )
    mapUsers = yamlencode(var.map_users)
  }

  depends_on = [aws_eks_cluster.this]
}
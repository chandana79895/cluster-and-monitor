terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

data "aws_eks_cluster" "terraform-eks" {
  name = "terraform-eks"
}
data "aws_eks_cluster_auth" "terraform-eks_auth" {
  name = "terraform-eks_auth"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.terraform-eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.terraform-eks.certificate_authority[0].data)
  version          = "2.16.1"
  config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "terraform-eks"]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "sock-shop"
  }
}
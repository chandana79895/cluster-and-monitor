terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
        version = ">= 2.0.0"
        source = "hashicorp/kubernetes"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


data "aws_eks_cluster" "terraform-eks" {
  name = "terraform-eks"
}
data "aws_eks_cluster_auth" "terraform-eks_auth" {
  name = "terraform-eks_auth"
}


provider "aws" {
  region     = "us-east-1"
}

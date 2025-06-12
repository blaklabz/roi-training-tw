# main.tf

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "capstone-pipelines2-tw"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.10.0"
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    spot_node_group = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      labels = {
        lifecycle = "spot"
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

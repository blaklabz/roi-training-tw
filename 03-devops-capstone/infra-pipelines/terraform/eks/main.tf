provider "aws" {
  region = var.region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnets
  vpc_id          = var.vpc_id
  enable_irsa     = true

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    nodegroup-1 = {
      desired_size = 2
      max_size     = 4
      min_size     = 2

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      ami_type       = "AL2_x86_64"

      attach_cluster_primary_security_group = true
      subnet_ids                            = var.private_subnets

      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicy",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess",
        "arn:aws:iam::aws:policy/AutoScalingFullAccess",
        "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      ]
    }
  }

  fargate_profiles = {
    on-fargate = {
      selectors = [{
        namespace = "on-fargat"
      }]
    }

    myprofile = {
      selectors = [{
        namespace = "prod"
        labels = {
          stack = "frontend"
        }
      }]
    }
  }

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
    amazon-cloudwatch-observability = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

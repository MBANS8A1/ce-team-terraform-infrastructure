module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets_ids
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

 
  eks_managed_node_groups = {
    one = {
      name = "eks-node-group-1"

      instance_types = ["t3.small"]

      min_size     = var.min_size
      desired_size = var.desired_size
      max_size     = var.max_size
    }
  }
}
module "networking"{
    source = "./modules/networking"
    cidr_block_range = var.cidr_block_range
    hostnames_enabled = var.hostnames_enabled
    dns_allowed = var.dns_allowed
    public_subnets_cidr = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    vpc_name = var.vpc_name
    availability_zones = var.availability_zones
    environment = var.environment
    connectivity_type = var.connectivity_type
    cluster_name = var.cluster_name
}

module "security"{
    source = "./modules/security"
    vpc_id = module.networking.vpc_id
}


 
module "rds"{
 source = "./modules/rds"
  use_secrets_manager = var.use_secrets_manager
  public-subnets-cidr-ids = module.networking.public-subnets-cidr-ids
  security_group_ids = module.security.security_group_ids
  db_username = var.db_username
  db_password = var.db_password
  engine = var.engine
  engine_version = var.engine_version
  secrets_list = var.secrets_list
  allocated_storage = var.allocated_storage
  rds_instance_name = var.rds_instance_name
  instance_class = var.instance_class
  db_subnet_grp_name = var.db_subnet_grp_name
  identifierName = var.identifierName
}

module "eks" {
    source          = "./modules/eks-containerisation"
    vpc_id          = module.networking.vpc_id
    cluster_name    = var.cluster_name
    min_size = var.min_size
    max_size = var.max_size
    desired_size = var.desired_size
    private_subnets_ids = module.networking.public-subnets-cidr-ids
    environment = var.environment    
}


provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
resource "aws_ecrpublic_repository" "repoimages" {
  provider = aws.us_east_1
  for_each =       toset(var.ecr_names)
  repository_name = each.value
  catalog_data {
    about_text        = "Contains docker images using maven and spring framework"
    description       = "Repository for Learner Management images"
    operating_systems = ["Linux"]
    usage_text        = "Follow push commands to push up docker image into the repository"
  }
  tags = {
    Name = each.value
    Environment = "${var.environment}"
  }
}
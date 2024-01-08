region    = "eu-west-2"
cidr_block_range = "10.0.0.0/16"
hostnames_enabled = true
dns_allowed = true
public_subnets_cidr = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]
private_subnets_cidr = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
vpc_name = "GROUP6-PROJECT-VPC"
availability_zones = ["eu-west-2a","eu-west-2b","eu-west-2c"]
environment = "dev"
connectivity_type = "public"



db_subnet_grp_name = "rds-subnet-project-group"
db_username =  "postgres"
db_password = "passwordsix"
rds_instance_name = "learnerdb"
allocated_storage = 10
instance_class = "db.t3.micro"
engine_version = "14.7"
engine = "postgres"
secrets_list = ["USERNAME","PASSWORD"]
use_secrets_manager = true
identifierName = "learnerdb"


cluster_name = "EKS-GROUP6-CLUSTER"
min_size = 1
max_size = 3
desired_size = 2

ecr_names = ["frontend_proj_ecr","backend_proj_ecr"]

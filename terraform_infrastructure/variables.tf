
variable "region" {
  description = "AWS region"
  type        = string
}

variable cidr_block_range{
   type = string
   description = "CIDR range the VPC will operate in"
}

variable ecr_names{
    type = list(string)
    description = "Names of the Elastic Container Registry"
}

variable environment{
    type = string
    description = "Environment infrastructure is deployed within"
}

variable hostnames_enabled{
   type = bool
   description = "Whether doman names are allowed"
}

variable dns_allowed{
   type = bool
   description = "Whether conversion of domain names to IP addresses is allowed"
}

variable vpc_name {
    type = string
    description = "Name decided for VPC"
}

variable public_subnets_cidr{
    type = list(string)
    description = "List of public subnetworks for public IP-related infrastructure"
}

variable private_subnets_cidr{
    type = list(string)
    description = "List of private subnetworks for private infrastructure to send egress traffic outside VPC"
}

variable availability_zones{
    type = list(string)
    description = "List regional AWS account available zones to place infrastructure"
}

variable connectivity_type {
    type = string
    description = "Whethere connectivity of NAT gateway is public or private"
}

variable "secrets_list"{
    type = list(string)
    description = "List of secret names"
}


variable "db_username"{
    type = string
    description = "Database username"
   
}

variable "db_password"{
    type = string
    description = "Database password"

}
variable "rds_instance_name"{
    type = string
    description = "RDS instance name"
   
}


variable "allocated_storage"{
    type = number
    description = "amount of storage for DB instance"

}

variable "instance_class" {
    type = string
    description = "instance class"
}

variable "engine_version"{
    type = string
    description = "engine version"
}

variable "engine"{
    type = string
    description ="engine for chosen relational database"
}


variable "use_secrets_manager"{
    type = bool
    description = "Whether to use secrets manager"
}

variable "db_subnet_grp_name" {
    type = string
    description = "database subnet group name"

}

variable "cluster_name" {
  description = "The name of the EKS cluster that will contain running pods and containers"
  type        = string
}

variable "min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
}

variable "desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
}
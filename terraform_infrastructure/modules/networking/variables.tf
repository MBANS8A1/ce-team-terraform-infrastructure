variable cidr_block_range{
   type = string
   description = "CIDR range the VPC will operate in"
}

variable environment{
    type = string
    description = "Environment infrastructure is deployed within"
}

variable hostnames_enabled{
   type = bool
   description = "Whether domain names are allowed"
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

variable cluster_name {
    type = string
    description = "The name of the EKS cluster that will contain running pods and containers"
}
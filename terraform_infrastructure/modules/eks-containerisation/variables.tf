variable private_subnets_ids{
    type = list(string)
    description = "List of private subnetwork ids"
}

variable vpc_id{
    type = string
    description = "Id of the vpc"
}

variable environment{
    type = string
    description = "Environment infrastructure is deployed within"
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


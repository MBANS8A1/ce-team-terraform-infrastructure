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

variable "public-subnets-cidr-ids"{
    type = list(string)
    description = "public subnet block ids"
}

variable "security_group_ids"{
    type = list(string)
    description = "security group ids"

}

variable "use_secrets_manager"{
    type = bool
    description = "Whether to use secrets manager"
}

variable "db_subnet_grp_name" {
    type = string
    description = "database subnett group name"

}

variable "identifierName"{
    type = string
    description = "identifier name"
} 
data "aws_secretsmanager_secret" "rds_secret" {
  count = length(var.secrets_list)
  name = element(var.secrets_list,count.index)
}

data "aws_secretsmanager_secret_version" "secret-rds-version" {
  count = length(var.secrets_list)
  secret_id = data.aws_secretsmanager_secret.rds_secret[count.index].id
}


resource "aws_db_instance" "project-rds-ins" {
  allocated_storage    = var.allocated_storage
  db_name              = var.rds_instance_name
  publicly_accessible  = true
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.db_username
  password             = var.db_password
  identifier           = var.identifierName
  # manage_master_user_password = var.use_secrets_manager
  # master_user_secret_kms_key_id = aws_kms_key.rds_group_key.key_id
  db_subnet_group_name = aws_db_subnet_group.rds_sub_grp.name
  vpc_security_group_ids = var.security_group_ids


}

#   password             = var.db_password

# resource "aws_kms_key" "rds_group_key" {
#   description = "Test KMS Key"
#   deletion_window_in_days = 10
#   enable_key_rotation = true
#   #important to make enable_key_rotation_ for terraform_apply to work
# }

# resource "aws_kms_key_policy" "project_policy" {
#   key_id = aws_kms_key.rds_group_key.id
#   policy = jsonencode({
#     Id = "example_policy"
#     Statement = [
#       {
#         Action = "kms:*"
#         Effect = "Allow"
#         Principal = {
#           AWS = "*"
#         }

#         Resource = "*"
#         Sid      = "Enable IAM User Permissions"
#       },
#     ]
#     Version = "2012-10-17"
#   })
# }


resource "aws_db_subnet_group" "rds_sub_grp" {
  name       = var.db_subnet_grp_name
  subnet_ids = var.public-subnets-cidr-ids
  tags = {
    Name = "RDS subnet group"
  }
}


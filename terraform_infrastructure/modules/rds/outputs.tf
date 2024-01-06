output "postgres_secrets" {
 value = [for secret_version in data.aws_secretsmanager_secret_version.secret-rds-version[*]: secret_version.secret_string]
 sensitive = true
}

output "rds_instance_endpoint" {
  value = aws_db_instance.project-rds-ins.address
}

output "rds_instance_endpoint-port" {
  value = aws_db_instance.project-rds-ins.port
}
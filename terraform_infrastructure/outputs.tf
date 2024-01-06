
output "region" {
  description = "AWS region"
  value       = var.region
}


output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "postgressql_secrets" {
 value = module.rds.postgres_secrets
 sensitive = true
}

output "rds_instance_endpoint_path" {
  value = module.rds.rds_instance_endpoint
}

output "rds_instance_endpoint-port" {
  value = module.rds.rds_instance_endpoint-port
}
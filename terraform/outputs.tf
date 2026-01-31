# =============================================================================
# Outputs
# =============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB Zone ID"
  value       = module.alb.alb_zone_id
}

output "ecs_cluster_name" {
  description = "ECS Cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = module.ecs.service_name
}

output "codedeploy_app_name" {
  description = "CodeDeploy application name"
  value       = module.codedeploy.app_name
}

output "codedeploy_deployment_group" {
  description = "CodeDeploy deployment group name"
  value       = module.codedeploy.deployment_group_name
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "application_url" {
  description = "Application URL"
  value       = "http://${module.alb.alb_dns_name}"
}

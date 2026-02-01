# =============================================================================
# Root Module - Main Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# VPC Module
# -----------------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

# -----------------------------------------------------------------------------
# Security Module
# -----------------------------------------------------------------------------
module "security" {
  source = "./modules/security"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

# -----------------------------------------------------------------------------
# ECR Module
# -----------------------------------------------------------------------------
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

# -----------------------------------------------------------------------------
# RDS Module
# -----------------------------------------------------------------------------
module "rds" {
  source = "./modules/rds"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  db_security_group_id = module.security.db_security_group_id
  db_instance_class   = var.db_instance_class
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
}

# -----------------------------------------------------------------------------
# ALB Module
# -----------------------------------------------------------------------------
module "alb" {
  source = "./modules/alb"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
  container_port         = var.container_port
}

# -----------------------------------------------------------------------------
# ECS Module
# -----------------------------------------------------------------------------
module "ecs" {
  source = "./modules/ecs"

  project_name           = var.project_name
  environment            = var.environment
  aws_region             = var.aws_region
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  ecs_security_group_id  = module.security.ecs_security_group_id
  ecr_repository_url     = module.ecr.repository_url
  target_group_blue_arn  = module.alb.target_group_blue_arn
  target_group_green_arn = module.alb.target_group_green_arn
  container_port         = var.container_port
  desired_count          = var.desired_count
  task_cpu               = var.task_cpu
  task_memory            = var.task_memory
  
  # Application environment variables
  app_key        = var.app_key
  db_host        = module.rds.db_endpoint
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  alb_dns_name   = module.alb.alb_dns_name
}

# -----------------------------------------------------------------------------
# CodeDeploy Module (Blue-Green Deployment)
# -----------------------------------------------------------------------------
module "codedeploy" {
  source = "./modules/codedeploy"

  project_name           = var.project_name
  environment            = var.environment
  ecs_cluster_name       = module.ecs.cluster_name
  ecs_service_name       = module.ecs.service_name
  alb_listener_arn       = module.alb.listener_arn
  target_group_blue_name = module.alb.target_group_blue_name
  target_group_green_name = module.alb.target_group_green_name
}

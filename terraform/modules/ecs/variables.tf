# ECS Module - Variables

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group ID"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "target_group_blue_arn" {
  description = "Blue target group ARN"
  type        = string
}

variable "target_group_green_arn" {
  description = "Green target group ARN"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "task_cpu" {
  description = "CPU units"
  type        = number
}

variable "task_memory" {
  description = "Memory in MB"
  type        = number
}

variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

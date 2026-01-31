# =============================================================================
# Input Variables
# =============================================================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "067847734974"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "laravel-blog"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ECS Variables
variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Memory for the task in MB"
  type        = number
  default     = 1024
}

# RDS Variables
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "laravel"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "laravel_admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

# Application Variables
variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
}

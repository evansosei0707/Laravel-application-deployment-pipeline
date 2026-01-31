# CodeDeploy Module - Variables

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB production listener ARN"
  type        = string
}

variable "target_group_blue_name" {
  description = "Blue target group name"
  type        = string
}

variable "target_group_green_name" {
  description = "Green target group name"
  type        = string
}

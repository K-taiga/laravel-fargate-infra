// referenced by ecspresso
data "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs/${local.name_prefix}-${local.service_name}/nginx"
}

data "aws_cloudwatch_log_group" "php" {
  name = "/ecs/${local.name_prefix}-${local.service_name}/php"
}

data "aws_ecr_repository" "nginx" {
  name = "${local.name_prefix}-${local.service_name}-nginx"
}

data "aws_ecr_repository" "php" {
  name = "${local.name_prefix}-${local.service_name}-php"
}

data "aws_iam_role" "ecs_task_execution" {
  name = "${local.name_prefix}-${local.service_name}-ecs-task-execution"
}

data "aws_iam_role" "ecs_task" {
  name = "${local.name_prefix}-${local.service_name}-ecs-task"
}

data "aws_lb_target_group" "this" {
  name = "${local.name_prefix}-bodoge-cafe-reviews"
}

data "aws_security_group" "db_laravel-fargate-app" {
  name = "${local.name_prefix}-main-db_laravel-fargate-app"
}

data "aws_security_group" "cache_laravel-fargate-app" {
  name = "${local.name_prefix}-main-cache_laravel-fargate-app"
}

data "aws_security_group" "vpc" {
  name = "${local.name_prefix}-main-vpc"
}

data "aws_subnet" "private" {
  for_each = var.azs
  tags = {
    Name = "${local.name_prefix}-main-private-${each.key}"
  }
}

variable "azs" {
  type = map(object({
    public_cidr  = string
    private_cidr = string
  }))

  default = {
    a = {
      public_cidr  = "172.31.0.0/20"
      private_cidr = "172.31.48.0/20"
    },
    c = {
      public_cidr  = "172.31.16.0/20"
      private_cidr = "172.31.64.0/20"
    }
  }
}
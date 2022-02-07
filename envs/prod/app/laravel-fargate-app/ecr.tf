module "nginx" {
  source = "../../../../modules/ecr"

  name = "example-prod-laravel-fargate-app-nginx"
}
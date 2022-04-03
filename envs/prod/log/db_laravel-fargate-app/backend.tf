terraform {
  backend "s3" {
    bucket = "k-taiga-tfstate"
    key    = "example/prod/log/db_laravel-fargate-appv1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}
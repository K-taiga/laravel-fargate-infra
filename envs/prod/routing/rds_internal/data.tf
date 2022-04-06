data "terraform_remote_state" "network_main" {
  backend = "s3"
  config = {
    bucket = "k-taiga-tfstate"
    key    = "${local.system_name}/${local.env_name}/network/main_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "db_laravel-fargate-app" {
  backend = "s3"
  config = {
    bucket = "k-taiga-tfstate"
    key    = "${local.system_name}/${local.env_name}/db/laravel-fargate-app_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}
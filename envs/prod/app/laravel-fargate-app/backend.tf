terraform {
  backend "s3" {
    bucket = "k-taiga-tfstate"
    # サービス名/各envsディレクトリに配置
    key    = "example/prod/app/laravel-fargate-app_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}

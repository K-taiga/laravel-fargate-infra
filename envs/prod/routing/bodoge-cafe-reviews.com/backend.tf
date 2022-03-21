terraform {
  backend "s3" {
    bucket = "k-taiga-tfstate"
    key    = "example/prod/routing/bodoge-cafereviews.com_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}
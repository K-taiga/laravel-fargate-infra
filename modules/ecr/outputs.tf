# moduleの呼び出し元からecrのURLを利用できるように設定
output "ecr_repository_this_repository_url" {
  value = aws_ecr_repository.this.repository_url
}
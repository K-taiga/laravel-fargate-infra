# resourceの種類,そのname
# nameの名付け方はスネーク,小文字と数字のみ,リソースの種類を含めない,一つだけのリソースの場合はthis
resource "aws_ecr_repository" "nginx" {
  # ケバブ,リソースの種類を名前に含まない,{システム名}-{環境名}-{サービス名}というprefix
  name = "example-prod-laravel-fargate-app-nginx"

  tags = {
    Name = "example-prod-laravel-fargate-app-nginx"
  }
}

# 上記のecrのpolicy
resource "aws_ecr_lifecycle_policy" "nginx" {
  # jsonでpolicyを記述
  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "最新のイメージ10コのみを保持,それより古いものは破棄",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "imageCountMoreThan",
            "countNumber" : 10
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )

  repository = aws_ecr_repository.nginx.name
}
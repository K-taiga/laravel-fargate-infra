resource "aws_ecr_repository" "this" {
  name = var.name

  tags = {
    Name = var.name
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  policy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "最新のイメージ${var.holding_count}コのみを保持,それより古いものは破棄",
          "selection" : {
            "tagStatus" : "any",
            "countType" : "imageCountMoreThan",
            "countNumber" : var.holding_count
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
  repository = aws_ecr_repository.this.name
}
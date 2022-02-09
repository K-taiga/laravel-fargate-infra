resource "aws_iam_user" "github" {
  # githubアクションに必要なAWSのアクセスキーを持つIAMを作成
  name = "${local.name_prefix}-${local.service_name}-github"

  tags = {
    Name = "${local.name_prefix}-${local.service_name}-github"
  }
}
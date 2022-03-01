resource "aws_iam_user" "github" {
  # githubアクションに必要なAWSのアクセスキーを持つIAMを作成
  name = "${local.name_prefix}-${local.service_name}-github"

  tags = {
    Name = "${local.name_prefix}-${local.service_name}-github"
  }
}

resource "aws_iam_role" "deployer" {
  name = "${local.name_prefix}-${local.service_name}-deployer"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole",
            "sts:TagSession"
          ],
          "Principal" : {
            "AWS" : aws_iam_user.github.arn
          }
        }
      ]
    }
  )

  tags = {
    Name = "${local.name_prefix}-${local.service_name}-deployer"
  }
}

data "aws_iam_policy" "ecr_power_user" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# roleにpolicyを紐付け
resource "aws_iam_role_policy_attachment" "role_deployer_policy_ecr_power_user" {
  role = aws_iam_role.deployer.name
  policy_arn = data.aws_iam_policy.ecr_power_user.arn
}
resource "aws_acm_certificate" "root" {
  domain_name       = data.aws_route53_zone.this.name
  validation_method = "DNS"

  tags = {
    Name = "${local.name_prefix}-bodoge-cafe-reviews.com"
  }

  # Terraformのlifecycle 新しいリソースを作成してから古いのを削除
  lifecycle {
    create_before_destroy = true
  }
}
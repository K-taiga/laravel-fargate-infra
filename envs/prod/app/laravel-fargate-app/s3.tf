resource "aws_s3_bucket" "env_file" {
  bucket = "k-taiga-${local.name_prefix}-${local.service_name}-env-file"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "k-taiga-${local.name_prefix}-${local.service_name}-env-file"
  }
}
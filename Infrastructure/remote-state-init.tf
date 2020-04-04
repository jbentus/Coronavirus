
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "coronavirus_terraform_state" {
  bucket        = "coronavirus-terraform-state"
  acl           = "private"

  # We want to have versioning enabled, because it allows us to keep track of
  # the Terraform state history
  versioning {
    enabled = true
  }

  # We also want to make sure our bucket enables server-side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Terraform state bucket for Coronavirus infrastructure"
  }
}
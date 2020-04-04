
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = "> 0.12.7"

  backend "s3" {
    bucket = "coronavirus-terraform-state"
    key    = "terraform.state"
    region = "us-east-1"
  }
}
# Another data source we will need later is one that will help us get th emost up-to-date AWS EC2 AMI that is ECS optimized.
# The AMI is nothing more than a codename (e.g. “ami-1234567”) that identifies a template that you can use to
# jump start a brand new EC2.

# There are AMIs for the popular Linux distributions: Ubuntu, Debian, etc. The one we will retrieve below,
# is a Linux based AMI that is created and maintained by Amazon and includes the essential tools for an EC2
# to be able to work as an ECS instance (Docker, Git, the ECS agent, SSH).

locals {
    cluster_name = "coronavirus"
}

data "aws_ami" "ecs" {
  most_recent = true # get the latest version

  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-*"] # ECS optimized image
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "amazon" # Only official images
  ]
}
resource "aws_launch_configuration" "ecs_config_launch_config" {
  name_prefix                 = "${local.cluster_name}_ecs_cluster"
  image_id                    = "ami-00a8f3b59eec913dc"
  instance_type               = "t3.micro"

  enable_monitoring           = true

  associate_public_ip_address = true
  
  lifecycle {
    create_before_destroy = true
  }

  # This user data represents a collection of “scripts” that will be executed the first time the machine starts.
  # This specific example makes sure the EC2 instance is automatically attached to the ECS cluster that we create earlier
  # and marks the instance as purchased through the Spot pricing
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config
EOF

  security_groups = [ aws_security_group.sg_for_ec2_instances.id ]

  # If you want to SSH into the instance and manage it directly:
  # 1. Make sure this key exists in the AWS EC2 dashboard
  # 2. Make sure your local SSH agent has it loaded
  # 3. Make sure the EC2 instances are launched within a public subnet (are accessible from the internet)
  key_name             = "ssh-key"

  # Allow the EC2 instances to access AWS resources on your behalf, using this instance profile and the permissions defined there
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.arn
}
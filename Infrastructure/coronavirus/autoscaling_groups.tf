resource "aws_autoscaling_group" "coronavirus" {
  name_prefix = "${local.cluster_name}_asg_"

  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1

  # Use this launch configuration to define “how” the EC2 instances are to be launched
  launch_configuration      = aws_launch_configuration.ecs_config_launch_config.name

  lifecycle {
    create_before_destroy = true
  }

  vpc_zone_identifier = [ aws_subnet.public-subnet-1.id ]

  tags = [
    {
      key                 = "Name"
      value               = local.cluster_name,

      # Make sure EC2 instances are tagged with this tag as well
      propagate_at_launch = true
    }
  ]

  wait_for_capacity_timeout = "4m"
}
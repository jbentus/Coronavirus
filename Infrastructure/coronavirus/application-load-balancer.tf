resource "aws_alb" "coronavirus" {
    name                = local.cluster_name
    security_groups     = [ aws_security_group.sg_for_ec2_instances.id ]
    subnets             = [ aws_subnet.public-subnet-1.id, aws_subnet.private-subnet-1.id  ]

    # --> Commented out because EIP is not supported for ALBs    
    # subnet_mapping {
    #   subnet_id     = aws_subnet.public-subnet-1.id
    #   allocation_id = aws_eip.coronavirus.id
    # }

    # subnet_mapping {
    #   subnet_id     = aws_subnet.private-subnet-1.id
    #   allocation_id = aws_eip.coronavirus.id
    # }

    tags = {
      Name = local.cluster_name
    }
}

resource "aws_alb_target_group" "coronavirus" {
    name                = "coronavirus"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = aws_vpc.coronavirus.id
    depends_on          = [ aws_alb.coronavirus, aws_subnet.public-subnet-1, aws_subnet.private-subnet-1 ]

    deregistration_delay = 30

    health_check {
        healthy_threshold   = "2"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200,307"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags = {
      Name = local.cluster_name
    }
}

resource "aws_lb_listener" "coronavirus-http" {
    load_balancer_arn = aws_alb.coronavirus.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.coronavirus.arn
        type             = "forward"
    }
}

# resource "aws_lb_listener" "coronavirus-https" {
#   load_balancer_arn = aws_alb.coronavirus.arn
#   port              = "443"
#   protocol          = "HTTPS"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.coronavirus.arn
#   }
# }
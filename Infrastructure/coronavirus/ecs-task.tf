resource "aws_ecs_task_definition" "coronavirus" {
  family = local.cluster_name

  execution_role_arn = aws_iam_role.ecs_tasks_execution_role.arn

  container_definitions = <<EOF
[
  {
    "name": "coronavirus",
    "image": "866969444757.dkr.ecr.us-east-1.amazonaws.com/coronavirus-server:latest",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-east-1",
        "awslogs-group": "coronavirus",
        "awslogs-stream-prefix": "complete-ecs"
      }
    },
    "requires_compatibilities": "EC2",
    "essential": true,
    "portMappings": [
      {
        "hostPort": 80,
        "containerPort": 80,
        "protocol": "tcp"
      },
      {
        "hostPort": 443,
        "containerPort": 443,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "coronavirus" {
  name = "coronavirus"
  iam_role        = aws_iam_role.ecs-service-role.name # IAM roles are only valid for services configured to use load balancers.
  depends_on      = [ data.aws_iam_policy_document.ecs-service-policy, aws_alb_target_group.coronavirus ]
  cluster = local.cluster_name
  task_definition = aws_ecs_task_definition.coronavirus.arn

  desired_count = 1

  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    	target_group_arn  = aws_alb_target_group.coronavirus.arn
    	container_port    = 80
    	container_name    = local.cluster_name
	}
}
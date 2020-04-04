resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.cluster_name
}

resource "aws_cloudwatch_log_group" "coronavirus" {
  name              = local.cluster_name
  retention_in_days = 1
}
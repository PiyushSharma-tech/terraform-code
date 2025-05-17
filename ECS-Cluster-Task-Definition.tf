# Create an ECS Cluster
resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my-ecs-cluster"  # Change to your desired cluster name
}

# Create an ECS Task Definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family"  # Change to your desired task family name
  network_mode             = "awsvpc"          # Options: bridge, host, awsvpc
  requires_compatibilities = ["FARGATE"]           # Options: EC2, FARGATE
  cpu                      = "256"              # CPU units
  memory                   = "512"              # Memory in MiB

  container_definitions = jsonencode([
    {
      name      = "my-container"  # Change to your desired container name
      image     = "my-ecr-repo:latest"  # Change to your ECR image URI
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 80  # Change to your desired container port
          hostPort      = 80  # Change to your desired host port
          protocol      = "tcp"
        },
      ]
    },
  ])
}
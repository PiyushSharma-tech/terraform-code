resource "aws_ecr_repository" "my_ecr_repository" {
  name                 = "my-ecr-repo"  # Change to your desired repository name
  image_tag_mutability = "MUTABLE"      # Options: MUTABLE or IMMUTABLE
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = "dev"                 # Add any tags you need
    Project     = "my-project"
  }
}

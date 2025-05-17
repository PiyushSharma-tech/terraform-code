resource "aws_sns_topic" "my_topic" {
  name = "my-sns-topic"  # Change as needed

  tags = {
    Name = "my-sns-topic"
  }
}

resource "aws_sqs_queue" "my_queue" {
  name = "my-sqs-queue"  # Change as needed

  tags = {
    Name = "my-sqs-queue"
  }
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn

  # Allow SNS to send messages to SQS
  raw_message_delivery = true
}

resource "aws_sqs_queue_policy" "my_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = "SQS:SendMessage"
        Resource = aws_sqs_queue.my_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.my_topic.arn
          }
        }
      }
    ]
  })
}

/*output "sns_topic_arn" {
  value = aws_sns_topic.my_topic.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.my_queue.id
}*/

###################################

/*provider "aws" {
  region = "us-east-1"  # Change as needed
}
*/

/*
variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "my-sns-topic"  # Change as needed
}

variable "sqs_queue_name" {
  description = "The name of the SQS queue"
  type        = string
  default     = "my-sqs-queue"  # Change as needed
}

resource "aws_sns_topic" "my_topic" {
  name = var.sns_topic_name

  tags = {
    Name = var.sns_topic_name
  }
}

resource "aws_sqs_queue" "my_queue" {
  name = var.sqs_queue_name

  tags = {
    Name = var.sqs_queue_name
  }
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn

  # Allow SNS to send messages to SQS
  raw_message_delivery = true
}

resource "aws_sqs_queue_policy" "my_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = "SQS:SendMessage"
        Resource = aws_sqs_queue.my_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.my_topic.arn
          }
        }
      }
    ]
  })
}
*/

/*output "sns_topic_arn" {
  value = aws_sns_topic.my_topic.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.my_queue.id
}
*/

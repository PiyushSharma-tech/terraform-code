# Create a CloudWatch Log Group
resource "aws_cloudwatch_log_group" "example_log_group" {
  name              = "example-log-group"
  retention_in_days = 14 # Change to your desired retention period
}

# Create a CloudWatch Metric Filter
resource "aws_cloudwatch_log_metric_filter" "example_metric_filter" {
  name           = "example-metric-filter"
  log_group_name = aws_cloudwatch_log_group.example_log_group.name
  pattern        = "{ $.level = \"ERROR\" }" # Change to your desired filter pattern

  metric_transformation {
    name      = "ErrorCount"
    namespace = "ExampleNamespace"
    value     = "1"
  }
}

# Create a CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "example_alarm" {
  alarm_name          = "example-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = aws_cloudwatch_log_metric_filter.example_metric_filter.metric_transformation[0].name
  namespace          = aws_cloudwatch_log_metric_filter.example_metric_filter.metric_transformation[0].namespace
  period             = "60" # Check every minute
  statistic          = "Sum"
  threshold          = "1" # Trigger alarm if there's at least one error
  alarm_description   = "This alarm triggers when the error count exceeds 1."

  # Specify actions to take when the alarm state changes
  alarm_actions = [] # Add SNS topic ARN or other actions here
}

# Optionally, create an SNS topic for alarm notifications
resource "aws_sns_topic" "example_sns_topic" {
  name = "example-sns-topic"
}

# Subscribe an email address to the SNS topic
resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_sns_topic.arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # Change to your email address
}

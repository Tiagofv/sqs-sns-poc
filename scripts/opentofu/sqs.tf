# Create an SQS Queue
resource "aws_sqs_queue" "payments_consumer_queue" {
  name                      = "app_consume_payments_queue"
  message_retention_seconds = 300
}

# SQS Queue Policy to allow SNS to send messages
resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.payments_consumer_queue.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["sns.amazonaws.com", "events.amazonaws.com"]
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.payments_consumer_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = [
              aws_sns_topic.payments.arn,
              aws_cloudwatch_event_target.sqs.arn,
              aws_cloudwatch_event_rule.evbridge-rule2.arn
            ]
          }
        }
      },
    ]
  })
}

# Configure the AWS Provider
provider "aws" {
  region = "sa-east-1"

}

resource "aws_iam_user" "app" {
  name = "example-sns-publisher"
}

# Create an IAM policy
resource "aws_iam_policy" "example" {
  name        = "example-sns-publish-policy"
  description = "A policy that allows publishing to the SNS topic"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = aws_sns_topic.payments.arn
      },
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.payments_consumer_queue.arn
      },
      {
        Action = [
          "events:PutEvents",
          "sts:assumeRole"
        ]
        Effect   = "Allow"
        Resource = aws_cloudwatch_event_bus.payments-event-bus.arn
      },

    ]
  })
}


# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.app.name
  policy_arn = aws_iam_policy.example.arn
}

resource "aws_cloudwatch_event_bus" "payments-event-bus" {
  name = "eventbus1"

}





# Output the SNS Topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.payments.arn
}

# Output the IAM User name
output "iam_user_name" {
  value = aws_iam_user.app.name
}


output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.payments-event-bus.arn
}
resource "aws_sns_topic" "payments" {
  name = "payments"

}

resource "aws_sns_topic_subscription" "payments_to_sqs_app" {
  endpoint  = aws_sqs_queue.payments_consumer_queue.arn
  protocol  = "sqs"
  topic_arn = aws_sns_topic.payments.arn

}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.payments.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.payments.arn]
  }
}

# Set SNS as a target for the EventBridge Rule
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.evbridge-rule.name
  event_bus_name = aws_cloudwatch_event_bus.payments-event-bus.name
  arn       = aws_sns_topic.payments.arn
  target_id = "SendToSNS"
}

# Set SNS as a target for the EventBridge Rule
resource "aws_cloudwatch_event_target" "sqs" {
  rule      = aws_cloudwatch_event_rule.evbridge-rule2.name
  event_bus_name = aws_cloudwatch_event_bus.payments-event-bus.name
  arn       = aws_sqs_queue.payments_consumer_queue.arn
  target_id = "SendToSQS"
}

# Create an EventBridge Rule
resource "aws_cloudwatch_event_rule" "evbridge-rule" {
  name           = "capture-events-from-payments-app"
  event_bus_name = aws_cloudwatch_event_bus.payments-event-bus.name
  event_pattern = jsonencode({
    "detail-type" : ["ExampleEvent"]
  })

  description = "Capture all payments events from the payments app"
}

# Create an EventBridge Rule
resource "aws_cloudwatch_event_rule" "evbridge-rule2" {
  name           = "capture-events-from-payments-app-sqs"
  event_bus_name = aws_cloudwatch_event_bus.payments-event-bus.name
  event_pattern = jsonencode({
    "detail-type" : ["ExampleEvent2"]
  })

  description = "Capture all payments events from the payments app directly to sqs"
}
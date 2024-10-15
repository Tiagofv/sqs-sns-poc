package main

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/eventbridge"
	"github.com/aws/aws-sdk-go/service/sqs"
	"os"
)

func main() {
	// Create a new AWS session
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("sa-east-1"), // replace with your AWS region
	})
	if err != nil {
		fmt.Println("Error creating session:", err)
		os.Exit(1)
	}

	// Create SNS and SQS clients
	eventBridge := eventbridge.New(sess)
	sqsClient := sqs.New(sess)
	eventBusArn := "arn:aws:events:sa-east-1:962948317754:event-bus/eventbus1"
	queueURL := "https://sqs.sa-east-1.amazonaws.com/962948317754/app_consume_payments_queue" // replace with your actual queue URL

	for i := 0; i < 10; i++ {
		publishResult := publishEvents(err, eventBridge, eventBusArn)
		fmt.Println("Message published! Message ID:", *publishResult.Entries[0].EventId)
	}

	// Receive messages from the SQS queue
	for {
		result, err := sqsClient.ReceiveMessage(&sqs.ReceiveMessageInput{
			QueueUrl:            aws.String(queueURL),
			MaxNumberOfMessages: aws.Int64(1),
			WaitTimeSeconds:     aws.Int64(20), // Long polling
		})
		if err != nil {
			fmt.Println("Error receiving message:", err)
			continue
		}

		if len(result.Messages) == 0 {
			fmt.Println("No messages received")
			continue
		}

		for _, message := range result.Messages {
			fmt.Println("Received message:", *message.Body)

			// Delete the message from the queue
			_, err = sqsClient.DeleteMessage(&sqs.DeleteMessageInput{
				QueueUrl:      aws.String(queueURL),
				ReceiptHandle: message.ReceiptHandle,
			})
			if err != nil {
				fmt.Println("Error deleting message:", err)
			}
		}

	}
}

func publishEvents(err error, eventBridge *eventbridge.EventBridge, eventBusArn string) *eventbridge.PutEventsOutput {
	// Publish a message to the SNS topic
	publishResult, err := eventBridge.PutEvents(&eventbridge.PutEventsInput{
		Entries: []*eventbridge.PutEventsRequestEntry{
			{
				Source:       aws.String("payments"),
				EventBusName: aws.String(eventBusArn),
				DetailType:   aws.String("ExampleEvent2"),
				Detail:       aws.String(`{"message": "Hello from EventBridge!", "Source": "payments"}`),
			}, {
				Source:       aws.String("payments"),
				EventBusName: aws.String(eventBusArn),
				DetailType:   aws.String("ExampleEvent2"),
				Detail:       aws.String(`{"message": "Hello from EventBridge1!", "Source": "payments"}`),
			},
		},
	})

	if err != nil {
		fmt.Println("Error publishing message:", err)
		os.Exit(1)
	}
	fmt.Println("failed count", *publishResult.FailedEntryCount)
	return publishResult
}

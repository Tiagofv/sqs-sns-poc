# Event Processing Infra

This project sets up the infrastructure for a event processing system using AWS services such as SQS, SNS, IAM, and EventBridge.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS account with appropriate permissions
- AWS CLI configured with your credentials

## Setting Up

1. **Configure your local access keys on your terminal:**

    ```sh
    export AWS_ACCESS_KEY_ID=<your-access-key-id>
    export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
    export AWS_REGION=sa-east-1
    ```

2. **Initialize Terraform:**

    ```sh
    terraform init
    ```

3. **Apply the Terraform configuration:**

    ```sh
    terraform apply
    ```

   This will create the necessary AWS resources.

## AWS Resources Created

- **SQS Queue**: `app_consume_payments_queue`
- **SNS Topic**: `payments`
- **IAM User**: `example-sns-publisher`
- **IAM Policy**: `example-sns-publish-policy`
- **EventBridge Event Bus**: `eventbus1`
- **EventBridge Rules**:
    - `capture-events-from-payments-app`
    - `capture-events-from-payments-app-sqs`

## Outputs

- **SNS Topic ARN**: The ARN of the SNS topic.
- **IAM User Name**: The name of the IAM user.
- **Event Bus ARN**: The ARN of the EventBridge event bus.

## Project Structure

- `scripts/opentofu/sqs.tf`: Configuration for SQS queue and its policy.
- `scripts/opentofu/main.tf`: Main configuration including IAM user, policy, and outputs.
- `scripts/opentofu/eventbridge.tf`: Configuration for EventBridge rules and targets.

## Running the App

To run the application, follow these steps:

1. **Install Go dependencies:**

    ```sh
    go mod tidy
    ```

2. **Build the application:**

    ```sh
    go build -o payment-app
    ```

3. **Run the application:**

    ```sh
    ./payment-app
    ```
   
Or just use `go run main.go` to run the application.

Make sure you have Go installed and properly configured on your system.

## License

This project is licensed under the MIT License.
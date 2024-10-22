package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
	Name string `json:"name"`
}

func HandleRequest(ctx context.Context, event *MyEvent) (events.APIGatewayProxyResponse, error) {

	if event == nil {
		return events.APIGatewayProxyResponse{Body: "an error occurred", StatusCode: 400}, fmt.Errorf("recieved nil event")
	}

	message := "Hello, world!"

	if event.Name != "" {
		message = fmt.Sprintf("Hello, %s", event.Name)
	}

	return events.APIGatewayProxyResponse{Body: message, StatusCode: 200}, nil
}

func main() {
	lambda.Start(HandleRequest)
}

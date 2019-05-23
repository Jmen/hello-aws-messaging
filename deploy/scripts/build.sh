#!/usr/bin/env bash

dotnet lambda package -pl ./src/HelloAwsMessaging.ApiGateway ./output/apigateway-lambda.zip
dotnet lambda package -pl ./src/HelloAwsMessaging.SqsToSns ./output/sqs-to-sns-lambda.zip
dotnet lambda package -pl ./src/HelloAwsMessaging.SnsToKinesis ./output/sns-to-kinesis-lambda.zip
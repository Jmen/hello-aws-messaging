using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using Amazon;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Amazon.SQS;
using Amazon.SQS.Model;
using Newtonsoft.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.ApiGateway
{
    public class Function
    {
        private readonly IAmazonSQS _sqs = new AmazonSQSClient(RegionEndpoint.USEast1);
        
        public async Task<APIGatewayProxyResponse> FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context)
        {
            await SendMessage();

            return SendResponse();
        }
        
        private async Task SendMessage()
        {
            var urlResponse = await _sqs.GetQueueUrlAsync(Environment.GetEnvironmentVariable("SQS_Queue_Name"));

            await _sqs.SendMessageAsync(new SendMessageRequest
            {
                QueueUrl = urlResponse.QueueUrl,
                MessageBody = $"This is my message text - {DateTime.UtcNow:F}",
            });
        }

        private static APIGatewayProxyResponse SendResponse()
        {
            var response = new APIGatewayProxyResponse
            {
                StatusCode = (int) HttpStatusCode.OK,
                Body = @"
                <html>
                <head>
                </head>
                <body>
                    <h1>Hello From Lambda</h1>
                    <h5>Written in C#</h5>
                    <h5>Deployed by Terraform</h5>
                </body>
                </html>",
                Headers = new Dictionary<string, string> {{"Content-Type", "text/html"}}
            };

            return response;
        }
    }
}
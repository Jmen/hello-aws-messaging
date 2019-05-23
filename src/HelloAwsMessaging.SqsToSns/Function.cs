using System;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.Lambda.SQSEvents;
using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;
using Newtonsoft.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.SqsToSns
{
    public class Function
    {
        private readonly IAmazonSimpleNotificationService _simpleNotificationService = new AmazonSimpleNotificationServiceClient();
        private readonly string _topicArn  = Environment.GetEnvironmentVariable("Topic_ARN");

        public async Task FunctionHandler(SQSEvent sqsEvent, ILambdaContext context)
        {
            foreach(var record in sqsEvent.Records)
            {
                await SendSns(record, context);
            }
        }

        private async Task SendSns(SQSEvent.SQSMessage sqsRecord, ILambdaContext context)
        {
            context.Logger.LogLine($"Processing message {sqsRecord.Body}");
            
            var request = new PublishRequest
            {
                Message = sqsRecord.Body,
                TopicArn = _topicArn,
            };
            
            var response = await _simpleNotificationService.PublishAsync(request);
            
            context.Logger.LogLine(JsonConvert.SerializeObject(response, Formatting.Indented));
        }
    }
}

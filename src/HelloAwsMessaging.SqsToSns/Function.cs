using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.Lambda.SQSEvents;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.SqsToSns
{
    public class Function
    {
        public async Task FunctionHandler(SQSEvent sqsEvent, ILambdaContext context)
        {
            foreach(var message in sqsEvent.Records)
            {
                await ProcessMessageAsync(message, context);
            }
        }

        private static async Task ProcessMessageAsync(SQSEvent.SQSMessage message, ILambdaContext context)
        {
            context.Logger.LogLine($"Processed message {message.Body}");

            // TODO: Do interesting work based on the new message
            await Task.CompletedTask;
        }
    }
}
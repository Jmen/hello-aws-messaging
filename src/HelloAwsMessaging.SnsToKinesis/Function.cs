using System;
using Amazon.Lambda.Core;
using Newtonsoft.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.SnsToKinesis
{
    public class Function
    {
        public void FunctionHandler(Amazon.Lambda.SNSEvents.SNSEvent.SNSMessage message, ILambdaContext context)
        {
            context.Logger.LogLine($"Processing message {JsonConvert.SerializeObject(message)}");
        }
    }
}
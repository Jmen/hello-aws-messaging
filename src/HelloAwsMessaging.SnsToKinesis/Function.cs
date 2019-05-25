using System;
using Amazon.Lambda.Core;
using Amazon.Lambda.SNSEvents;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.SnsToKinesis
{
    public class Function
    {
        public void FunctionHandler(SNSEvent message, ILambdaContext context)
        {
            context.Logger.LogLine($"Processing message {JsonConvert.SerializeObject(message)}");
        }
    }
}
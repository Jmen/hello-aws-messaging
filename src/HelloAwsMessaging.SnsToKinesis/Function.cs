using System;
using Amazon.Lambda.Core;
using Amazon.Lambda.SNSEvents;
using Amazon.XRay.Recorder.Handlers.AwsSdk;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.SnsToKinesis
{
    public class Function
    {
        public Function()
        {
            AWSSDKHandler.RegisterXRayForAllServices();
        }
        
        public void FunctionHandler(SNSEvent message, ILambdaContext context)
        {
            context.Logger.LogLine($"Processing message {JsonConvert.SerializeObject(message)}");
        }
    }
}
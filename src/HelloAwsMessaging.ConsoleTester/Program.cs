using System;
using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using HelloAwsMessaging.ApiGateway;
using Newtonsoft.Json;

namespace HelloAwsMessaging.ConsoleTester
{
    internal static class Program
    {
        private static async Task Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            
            Environment.SetEnvironmentVariable("SQS_Queue_Name", "hello-sqs-dev");
            
            var response = await new Function().FunctionHandler(new APIGatewayProxyRequest(), new FakeContext());
            
            Console.WriteLine(JsonConvert.SerializeObject(response, Formatting.Indented));
        }
    }
}
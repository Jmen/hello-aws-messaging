using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Newtonsoft.Json;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HelloAwsMessaging.ApiGateway
{
    public class Function
    {
        public APIGatewayProxyResponse FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context)
        {
            context.Logger.Log(JsonConvert.SerializeObject(request, Formatting.Indented));
            
            var response = new APIGatewayProxyResponse
            {
                StatusCode = (int)HttpStatusCode.OK,
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
                Headers = new Dictionary<string, string> { { "Content-Type", "text/html" } }
            };

            return response;
        }
    }
}
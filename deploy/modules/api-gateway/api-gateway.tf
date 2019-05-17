resource "aws_api_gateway_rest_api" "api" {
    name = "${var.name}"
}

resource "aws_api_gateway_method" "root_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
    resource_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"

    http_method   = "ANY"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_integration" {
    rest_api_id = "${aws_api_gateway_rest_api.api.id}"
    resource_id = "${aws_api_gateway_method.root_method.resource_id}"

    http_method             = "${aws_api_gateway_method.root_method.http_method}"
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_resource" "proxy_resource" {
    rest_api_id = "${aws_api_gateway_rest_api.api.id}"

    parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
    path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
    resource_id   = "${aws_api_gateway_resource.proxy_resource.id}"

    http_method   = "ANY"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_integration" {
    rest_api_id = "${aws_api_gateway_rest_api.api.id}"
    resource_id = "${aws_api_gateway_method.proxy_method.resource_id}"

    http_method             = "${aws_api_gateway_method.proxy_method.http_method}"
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_deployment.deployment.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
    depends_on = [
        "aws_api_gateway_integration.root_integration",
        "aws_api_gateway_integration.proxy_integration"
    ]

    rest_api_id = "${aws_api_gateway_rest_api.api.id}"
    stage_name  = "stage"
    stage_description = "${var.name} ${var.lambda_arn} ${var.lambda_invoke_arn} ${md5(file("./modules/api-gateway/api-gateway.tf"))}"
}


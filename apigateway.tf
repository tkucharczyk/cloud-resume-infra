resource "aws_apigatewayv2_api" "dynamodb_api" {
  name          = "DynamoDBIntegrationAPI"
  protocol_type = "HTTP"

  cors_configuration {
        allow_credentials = false
        allow_headers     = [
            "authorization",
            "content-type",
        ]
        allow_methods     = [
            "GET",
            "OPTIONS",
            "POST",
        ]
        allow_origins     = [
            "*",
        ]
        expose_headers    = [
            "visitcount",
        ]
        max_age           = 0
    }
}

resource "aws_apigatewayv2_integration" "get_visit_counter" {
  api_id                 = aws_apigatewayv2_api.dynamodb_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:lambda:eu-central-1:381492029034:function:getVisitCounter"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "post_visit_counter" {
  api_id                 = aws_apigatewayv2_api.dynamodb_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = "arn:aws:lambda:eu-central-1:381492029034:function:pageVisitCounter"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_route" {
  api_id    = aws_apigatewayv2_api.dynamodb_api.id
  route_key = "GET /visit"
  target    = "integrations/${aws_apigatewayv2_integration.get_visit_counter.id}"
}

resource "aws_apigatewayv2_route" "post_route" {
  api_id    = aws_apigatewayv2_api.dynamodb_api.id
  route_key = "POST /visit"
  target    = "integrations/${aws_apigatewayv2_integration.post_visit_counter.id}"
}

# Opcjonalna obsługa OPTIONS (CORS)
resource "aws_apigatewayv2_route" "options_route" {
  api_id    = aws_apigatewayv2_api.dynamodb_api.id
  route_key = "OPTIONS /visit"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.dynamodb_api.id
  name        = "$default"
  auto_deploy = true
}

# Uprawnienia do wywołania Lambd
resource "aws_lambda_permission" "get_permission" {
  statement_id  = "AllowApiGatewayInvokeGet"
  action        = "lambda:InvokeFunction"
  function_name = "getVisitCounter"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.dynamodb_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "post_permission" {
  statement_id  = "AllowApiGatewayInvokePost"
  action        = "lambda:InvokeFunction"
  function_name = "pageVisitCounter"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.dynamodb_api.execution_arn}/*/*"
}

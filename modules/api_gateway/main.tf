
resource "aws_api_gateway_resource" "root" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.root_resource_id
  path_part   = "Apache"
}

resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = var.api_gateway_id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "health"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_gateway" {
  rest_api_id             = var.api_gateway_id
  resource_id             = aws_api_gateway_resource.MyDemoResource.id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lamda_arn
}

resource "aws_api_gateway_deployment" "Deployement_app" {
  depends_on  = [aws_api_gateway_integration.integration_gateway]
  rest_api_id = var.api_gateway_id
  stage_name  = var.stage_name
}

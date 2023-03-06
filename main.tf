provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXAFLPFYT723VIXYM"
  secret_key = "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"
}
resource "aws_api_gateway_rest_api" "my_api_gateway" {
  name        =  var.api_name
  description = "This is my API for demonstration "
}

module "iam" {
  source       = "./modules/iam"
  lambda_function_name = var.lambda_function_name
  api_arn      = module.api_gateway.api_arn
  iam_role_arn = module.iam.iam_role_arn
  lamda_arn    = module.lamda.lamda_arn
}

module "lamda" {
  source        = "./modules/lamda"
  lambda_function_name = var.lambda_function_name
  lamda_arn     = module.lamda.lamda_arn
  iam_role_arn  = module.iam.iam_role_arn


}
module "api_gateway" {
  source           = "./modules/api_gateway"
  lamda_arn        = module.lamda.lamda_arn
  api_gateway_id   = aws_api_gateway_rest_api.my_api_gateway.id
  root_resource_id = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  stage_name       = var.stage_name
 
}


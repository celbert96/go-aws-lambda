terraform {
  required_version = ">=0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.59.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

data "archive_file" "myzip" {
  type        = "zip"
  source_file = "bootstrap"
  output_path = "deploy.zip"
}

resource "aws_lambda_function" "go_lambda" {
  filename      = "deploy.zip"
  function_name = "go_lambda_function"
  role          = aws_iam_role.go_lambda_role.arn
  handler       = "lambda_handler"
  runtime       = "provided.al2023"
}

resource "aws_iam_role" "go_lambda_role" {
  name = "go_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

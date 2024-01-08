terraform {
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
  backend "s3" {
    bucket = "eks-group-six-bucket" 
    region = "eu-west-2"
    key = "ce-learner-management-system/terraform_infrastructure/terraform.tfstate"
    dynamodb_table = "eks-group-six-table"
  }
}

provider "aws" {
  region = var.region
}

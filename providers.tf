terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.3.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2"
    }
  }
  required_version = "~> 1.15.8"
}

provider "aws" {
  region = var.aws_region
}
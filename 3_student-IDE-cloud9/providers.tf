##############################################################################################################
# Terraform providers
##############################################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = local.region["id"]
}

##############################################################################################################
# Providers variables
############################################################################################################### 
// AWS configuration
variable "access_key" {}
variable "secret_key" {}

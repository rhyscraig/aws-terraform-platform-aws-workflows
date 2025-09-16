provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

variable "region" {
  description = "AWS region for account provisioning"
  type        = string
  default     = "eu-west-1"
}

variable "default_tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

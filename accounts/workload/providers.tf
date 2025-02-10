#Configure the AWS Provider

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
    }
}

provider "aws"{
  alias = "shared_services"
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Workload"
      Application = "Workload"
      Region      = "Virginia"
      Deployment  = "Terraform Cloud workspace: centrailized-vpc-tgw-demo"
    }
  }
  assume_role {
    role_arn = "arn:aws:iam::<ACCOUNT-NUMBER>:role/network-assume-role"
    external_id = "1FD80517-7EB0-4255"
  }
}
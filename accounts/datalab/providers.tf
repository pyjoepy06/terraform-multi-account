#Configure the AWS Provider

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
    }
}

provider "aws"{
  alias = "data_lab_east"
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Data Lab"
      Application = "ML/AI"
      Region      = "Virginia"
    }
  }
  assume_role {
    role_arn = "arn:aws:iam::<ACCOUNT-NUMBER>:role/convergeone-network-assume-role"
    external_id = "1FD80517-7EB0-5542"
  }
}
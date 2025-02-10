#Configure the AWS Provider
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Test"
      Application = "Demo"
      Region      = "Virginia"
      Deployment  = "Terraform Cloud workspace: centrailized-vpc-tgw-demo"
    }
  }
}

provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "Test"
      Application = "Demo"
      Region      = "Oregon"
      Deployment  = "Terraform Cloud workspace: centrailized-vpc-tgw-demo"
    }
  }
}
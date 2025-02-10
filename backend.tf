terraform {
  backend "remote" {
    organization = "ConvergeOne"
    hostname     = "app.terraform.io"
    workspaces {
      name = "centrailized-vpc-tgw-demo"
    }
  }
}
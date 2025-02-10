terraform {
  backend "remote" {
    organization = "ConvergeOne"
    hostname     = "app.terraform.io"
    workspaces {
      name = "decentralized-workload-demo"
    }
  }
}
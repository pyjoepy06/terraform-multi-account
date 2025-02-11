terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}

# terraform {
#   backend "remote" {
#     organization = "<MyOrganization-Name>"
#     hostname     = "app.terraform.io"
#     workspaces {
#       name = "centrailized-vpc-tgw-demo"
#     }
#   }
# }
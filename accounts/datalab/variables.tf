variable "region" {
  description = "The region where Terraform will deploy infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "transit_gw_id" {
  description = "The region where Terraform will deploy infrastructure."
  type        = string
  default     = "tgw-0e3c39ecbcd5da"
}

# variable "default_tags"{
#   type = map(string)
#   description = "Map of default tags to apply to resources"
#   default = {
#     project = "CloudEndure Resource"
#   }
# }
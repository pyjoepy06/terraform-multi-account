#Production VPC
module "data_lab_vpc" {
  source = "../../modules/vpc"

  cidr_block            = "10.221.6.0/23"                        #VPC CIDR to deploy, provided by client
  name                  = "pyjoepy-data-lab"       #VPC Name ex. staging
  public_subnets        = ["10.221.6.0/25", "10.221.7.0/25"]     # A list of subnets to deploy
  private_subnets       = ["10.221.6.128/25", "10.221.7.128/25"] # A list of subnets to deploy
  availability_zones    = ["us-east-1c", "us-east-1d"]           # A list AZs for each subnet
  enable_nat_gateway    = false                                  #If true enable NAT Gateways for Private Subnets, Optional
  single_nat_gateway    = false                                  #If true enable One NAT gateway for Private Subnets to share, Optional
  providers = {
    aws = aws.data_lab_east
  }
}

#Attach Production VPC to Transit Gateway
# module "data_lab_vpc_tgw_attach" {
#   source = "../../modules/transit_vpc_attach"

#   subnet_ids              = module.data_lab_vpc.private_subnets #Manually add or use private subnets module.data_lab_vpc.private_subnets
#   transit_gw_id           = var.transit_gw_id #"{transit-gateway-id-here}"
#   vpc_id                  = module.data_lab_vpc.vpc_id
#   pub_route_tables        = module.data_lab_vpc.public_rtb_id
#   pri_route_tables        = module.data_lab_vpc.private_rtb_id
#   single_ngw_route_tables = module.data_lab_vpc.single_nat_gw_rtb_id #If NAT Gateways are created route tables get updated else null
#   multi_ngw_route_tables  = module.data_lab_vpc.multi_nat_gw_rtb_id  #If NAT Gateways are created route tables get updated else null
#   providers = {
#     aws = aws.data_lab_east
#   }
# }

# #Security Groups - Custom code please update as needed - Optional
# module "datalab_security_groups" {
#   source = "./modules/security_groups"
#   vpc_id = module.data_lab_vpc.vpc_id
# }

# #Key Pair - Optional
# module "pyjoepy_key_pair" {
#   source   = "./modules/key_pair"
#   key_name = "pyjoepy_key"
# }

# #Bastion Server - Optional

# module "artesia_staging_vpc_bastion_windows" {
#   source                 = "./modules/ec2"
#   name                   = "bastion-staging-server"
#   instance_count         = 1
#   ami                    = "ami-01977bpyjoepy5980f9223" #Windows 2019 Bastion us-west-2 02/15/2022 find your AMI needed for your region and OS type
#   instance_type          = "t2.micro"
#   subnet_id              = module.data_lab_vpc.public_subnets[0]
#   private_ip             = ["{IP from subnet-id provided above}"]
#   vpc_security_group_ids = [module.datalab_security_groups.custom_security_group]
#   key_name               = module.pyjoepy_key_pair.key_pair_key_name #Or Create manually and pass as string "my_key_pair name"
# }
#Production VPC
module "workload_vpc" {
  source = "../../modules/vpc"

  cidr_block            = "10.221.10.0/23"                        #VPC CIDR to deploy, provided by client
  name                  = "pyjoepy-workload"       #VPC Name ex. staging
  public_subnets        = ["10.221.10.0/25", "10.221.11.0/25"]     # A list of subnets to deploy
  private_subnets       = ["10.221.10.128/25", "10.221.11.128/25"] # A list of subnets to deploy
  availability_zones    = ["us-east-1f", "us-east-1e"]           # A list AZs for each subnet
  enable_nat_gateway    = false                                  #If true enable NAT Gateways for Private Subnets, Optional
  single_nat_gateway    = false                                  #If true enable One NAT gateway for Private Subnets to share, Optional
  providers = {
    aws = aws.virginia
  }
}

#Attach Production VPC to Transit Gateway
# module "workload_vpc_tgw_attach" {
#   source = "../../modules/transit_vpc_attach"

#   subnet_ids              = module.workload_vpc.private_subnets #Manually add or use private subnets module.workload_vpc.private_subnets
#   transit_gw_id           = "{transit-gateway-id-here}"
#   vpc_id                  = module.workload_vpc.vpc_id
#   pub_route_tables        = module.workload_vpc.public_rtb_id
#   pri_route_tables        = module.workload_vpc.private_rtb_id
#   single_ngw_route_tables = module.workload_vpc.single_nat_gw_rtb_id #If NAT Gateways are created route tables get updated else null
#   multi_ngw_route_tables  = module.workload_vpc.multi_nat_gw_rtb_id  #If NAT Gateways are created route tables get updated else null
#   providers = {
#     aws = aws.virginia
#   }
# }

# #Security Groups - Custom code please update as needed - Optional
# module "staging_sg" {
#   source = "./modules/security_groups"
#   vpc_id = module.workload_vpc.vpc_id
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
#   subnet_id              = module.workload_vpc.public_subnets[0]
#   private_ip             = ["{IP from subnet-id provided above}"]
#   vpc_security_group_ids = [module.staging_sg.custom_security_group]
#   key_name               = module.pyjoepy_key_pair.key_pair_key_name #Or Create manually and pass as string "my_key_pair name"
# }
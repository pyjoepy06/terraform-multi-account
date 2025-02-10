#Production VPC
module "network_production_vpc" {
  source = "./modules/vpc"

  cidr_block            = "10.221.0.0/23"                        #VPC CIDR to deploy, provided by client
  name                  = "pyjoepy-network-production"       #VPC Name ex. staging
  public_subnet_suffix  = "bastion"                              #Optional default tag will be "public"
  private_subnet_suffix = "database"                             #Optional default tag will be "private"
  public_subnets        = ["10.221.0.0/25", "10.221.1.0/25"]     # A list of subnets to deploy
  private_subnets       = ["10.221.0.128/25", "10.221.1.128/25"] # A list of subnets to deploy
  availability_zones    = ["us-east-1a", "us-east-1b"]           # A list AZs for each subnet
  enable_nat_gateway    = false                                  #If true enable NAT Gateways for Private Subnets, Optional
  single_nat_gateway    = false                                  #If true enable One NAT gateway for Private Subnets to share, Optional
  providers = {
    aws = aws.virginia
  }
}

#Development VPC
module "network_development_vpc" {
  source = "./modules/vpc"

  cidr_block         = "10.221.32.0/20"                     # VPC CIDR to deploy, provided by client
  name               = "pyjoepy-network-development"    # VPC Name ex. target
  public_subnets     = ["10.221.32.0/23", "10.221.34.0/23"] # A list of subnets to deploy
  private_subnets    = ["10.221.36.0/23", "10.221.38.0/23"] # A list of subnets to deploy
  availability_zones = ["us-east-1a", "us-east-1b"]         # A list AZs for each subnet
  enable_nat_gateway = true                                 #If true enable NAT Gateways for Private Subnets, Optional
  single_nat_gateway = true                                 #If true enable One NAT gateway for Private Subnets to share, Optional
  providers = {
    aws = aws.virginia
  }
}

#Firewall Palo Alto VPC
module "network_firewall_vpc" {
  source = "./modules/vpc"

  cidr_block            = "10.221.192.0/20"    # VPC CIDR to deploy, provided by client
  name                  = "palo-alto-firewall" # VPC Name ex. target
  public_subnet_suffix  = "outside"
  private_subnet_suffix = "inside_management_diag"
  public_subnets        = ["10.221.192.0/23", "10.221.194.0/23", "10.221.196.0/23"] # A list of subnets to deploy
  private_subnets       = ["10.221.198.0/23", "10.221.200.0/23", "10.221.202.0/23"] # A list of subnets to deploy
  availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]                # A list AZs for each subnet
  enable_nat_gateway    = true                                                      #If true enable NAT Gateways for Private Subnets, Optional
  single_nat_gateway    = false                                                     #If true enable One NAT gateway for Private Subnets to share, Optional
  providers = {
    aws = aws.virginia
  }
}

#Attach Production VPC to Transit Gateway
module "production_vpc_tgw_attach" {
  source = "./modules/transit_vpc_attach"

  subnet_ids              = module.network_production_vpc.private_subnets #Manually add or use private subnets module.network_production_vpc.private_subnets
  transit_gw_id           = var.transit_gw_id
  vpc_id                  = module.network_production_vpc.vpc_id
  pub_route_tables        = module.network_production_vpc.public_rtb_id
  pri_route_tables        = module.network_production_vpc.private_rtb_id
  single_ngw_route_tables = module.network_production_vpc.single_nat_gw_rtb_id #If NAT Gateways are created route tables get updated else null
  multi_ngw_route_tables  = module.network_production_vpc.multi_nat_gw_rtb_id  #If NAT Gateways are created route tables get updated else null
  providers = {
    aws = aws.virginia
  }
}

#Attach Development VPC to Transit Gateway
module "network_development_vpc_tgw_attach" {
  source = "./modules/transit_vpc_attach"

  subnet_ids              = module.network_development_vpc.private_subnets #Manually add or use private subnets module.network_development_vpc.private_subnets
  transit_gw_id           = var.transit_gw_id
  vpc_id                  = module.network_development_vpc.vpc_id
  pub_route_tables        = module.network_development_vpc.public_rtb_id
  pri_route_tables        = module.network_development_vpc.private_rtb_id
  single_ngw_route_tables = module.network_development_vpc.single_nat_gw_rtb_id #If NAT Gateways are created route tables get updated else null
  multi_ngw_route_tables  = module.network_development_vpc.multi_nat_gw_rtb_id  #If NAT Gateways are created route tables get updated else null
  providers = {
    aws = aws.virginia
  }
}

module "network_firewall_vpc_tgw_attach" {
  source = "./modules/transit_vpc_attach"

  subnet_ids              = module.network_firewall_vpc.private_subnets #Manually add or use private subnets module.network_firewall_vpc.private_subnets
  transit_gw_id           = var.transit_gw_id
  vpc_id                  = module.network_firewall_vpc.vpc_id
  pub_route_tables        = module.network_firewall_vpc.public_rtb_id
  pri_route_tables        = module.network_firewall_vpc.private_rtb_id
  single_ngw_route_tables = module.network_firewall_vpc.single_nat_gw_rtb_id #If NAT Gateways are created route tables get updated else null
  multi_ngw_route_tables  = module.network_firewall_vpc.multi_nat_gw_rtb_id  #If NAT Gateways are created route tables get updated else null
  providers = {
    aws = aws.virginia
  }
}

#Cross Account Terraform

#Shared Services Account VPC
module "shared_services_account" {
  source = "./accounts/shared_services"
}

#Data Lab Services Account VPC
module "data_lab_account" {
  source = "./accounts/datalab"
}

#Client VPN Build to TGW
# module "client_vpn_tgw" {
#   source = "./modules/transit_gateway_vpn"

#   transit_gw_id                          = module.transit_gateway.tgw_id
#   vpn_ip_address                         = "{Client VPN Public IP}"              #IP Address of client VPN endpoint
#   client_campus_network_routes           = [""]                                  #List of routes for campus ex. ["10.0.0.0/8"] or ["10.100.0.0/24", "172.31.0.0/24"]
#   tgw_association_default_route_table_id = module.transit_gateway.default_rtb_id #Or manually add a TGW RTB ID "tgw-rtb-abpyjoepy23"
# }

# #Security Groups - Custom code please update as needed - Optional
# module "staging_sg" {
#   source = "./modules/security_groups"
#   vpc_id = module.network_production_vpc.vpc_id
# }

# module "target_sg" {
#   source = "./modules/security_groups"
#   vpc_id = module.network_development_vpc.vpc_id
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
#   subnet_id              = module.production_vpc.public_subnets[0]
#   private_ip             = ["{IP from subnet-id provided above}"]
#   vpc_security_group_ids = [module.staging_sg.custom_security_group]
#   key_name               = module.pyjoepy_key_pair.key_pair_key_name #Or Create manually and pass as string "my_key_pair name"
# }

# module "artesia_target_vpc_bastion_windows" {
#   source                 = "./modules/ec2"
#   name                   = "bastion-target-server"
#   instance_count         = 1
#   ami                    = "ami-01977bpyjoepy5980f9223" #Windows 2019 Bastion us-west-2 02/15/2022 find your AMI needed for your region and OS type
#   instance_type          = "t2.micro"
#   subnet_id              = module.network_development_vpc.public_subnets[0]
#   private_ip             = ["{IP from subnet-id provided above}"]
#   vpc_security_group_ids = [module.target_sg.custom_security_group]
#   key_name               = module.pyjoepy_artesia_key_pair.key_pair_key_name #Or Create manually and pass as string "my_key_pair name"
# }


#Production Transit Gateway
# module "transit_gateway" {
#   source = "./modules/transit_gateway"

#   name        = "pyjoepy Lab TGW"              #TGW Name
#   description = "TGW for pyjoepy Demostration" #TGW Description
#   providers = {
#     aws = aws.virginia
#   }
# }
provider "aws" {
  region = "eu-west-1"
}

#####################################################################################
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
#####################################################################################
module "vpc" {
  source          = "git::https://github.com/SyncArcs/terraform-aws-vpc.git?ref=v1.0.0"
  name            = "vpc"
  environment     = "test"
  cidr_block      = "10.0.0.0/16"
  enable_flow_log = true
}

#####################################################################################
#### A subnet is a range of IP addresses in your VPC.
#####################################################################################
module "subnets" {
  source              = "git::https://github.com/SyncArcs/terraform-aws-subnet.git?ref=v1.0.0"
  name                = "subnet"
  environment         = "workspace-subnet"
  availability_zones  = ["eu-west-1a", "eu-west-1b", ]
  vpc_id              = module.vpc.id
  type                = "public-private"
  nat_gateway_enabled = true
  single_nat_gateway  = true
  cidr_block          = module.vpc.vpc_cidr_block
  igw_id              = module.vpc.igw_id

}

module "workspace" {
  source = "./../"
  name   = "workspace"
  ##ad
  subnet_ids = module.subnets.private_subnet_id
  vpc_settings = {
    vpc_id     = module.vpc.id
    subnet_ids = join(",", module.subnets.private_subnet_id)
  }

  ad_name                             = "ad.workspace.com"
  ad_password                         = "xyz123@abc"
  ip_whitelist                        = ["0.0.0.0/0"]
  enable_internet_access              = true
  user_enabled_as_local_administrator = true

  ##workspace
  enable_workspace = false
  #  workspace_bundle_id = "wsb-208l8k46h"
  // first run terraform apply with enable_workspace = false and then create custom user names in workspace manually and specify here that username and re-run tf apply with enable_workspace = true so that workspace with custom-username gets created .

  workspaces = {
    workspace1 = {
      user_name = "admin"
      bundle_id = "wsb-208l8k46h"
    }
  }
}
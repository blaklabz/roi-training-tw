provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "security_group" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
  sg_name = "capstone-web-sg"
}

/* this can be used instead of asg if wanted
module "ec2" {
  source = "./modules/ec2"
  ami_id            = var.ami_id
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.sg_id
  instance_name     = "capstone-ec2"
}
*/

module "alb" {
  source            = "./modules/alb"
  alb_name          = "capstone-alb"
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_group.sg_id
  vpc_id            = module.vpc.vpc_id
}

module "asg" {
  source            = "./modules/asg"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  security_group_id = module.security_group.sg_id
  subnet_ids        = module.vpc.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
}

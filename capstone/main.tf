module "vpc" {
  source = "./modules/vpc"
}
module "security_groups" {
    source = "./modules/security-group"
    vpc_id = module.vpc.vpc_id
    depends_on = [module.vpc]
}
module "alb" {
  source = "./modules/load-balancer"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id = module.security_groups.alb_sg_id
  depends_on = [module.vpc, module.security_groups]
}

module "asg" {
  source = "./modules/autoScaling"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
  sg_id = module.security_groups.ec2_sg_id
  # userdata_git_repo = "var.ss"
  ami_id = var.ami_id
  instance_type = var.instance_type
  depends_on = [module.alb]
}

module "rds" {
  source = "./modules/rds"
  subnet_ids = module.vpc.private_subnet_ids
  sg_id = module.security_groups.rds_sg_id
  depends_on = [module.vpc, module.security_groups]
 }

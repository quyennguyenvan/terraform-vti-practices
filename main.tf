
module "network" {
  source       = "./_modules/vpc"
  vpc_name     = var.vpc_name
  cidr_block   = var.cidr_block
  default_tags = var.default_tags
}

module "ec2instances" {
  depends_on                  = [module.network]
  source                      = "./_modules/ec2"
  for_each                    = var.ec2instances
  public_key                  = each.value.public_key
  trusted_ip_ranges           = each.value.trusted_ip_ranges
  ec2InstanceName             = each.value.ec2InstanceName
  ec2ami                      = each.value.ec2ami
  ec2InstanceType             = each.value.ec2InstanceType
  vpc_id                      = module.network.vpc_id
  ec2Pemfile                  = each.value.ec2Pemfile
  ec2UserConnect              = each.value.ec2UserConnect
  vpc_subnet_id               = sort(module.network.public_subnet_public_ids)[0]
  associate_public_ip_address = each.value.associate_public_ip_address
  security_group_rule_ingress = each.value.security_group.ingress
  security_group_rule_egress  = each.value.security_group.egress
  userdata                    = each.value.userdata
  default_tags                = var.default_tags
}

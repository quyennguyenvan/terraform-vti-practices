
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
  vpc_subnet_id               = sort(module.network.public_subnet_public_ids)[0]
  associate_public_ip_address = each.value.associate_public_ip_address
  default_tags                = var.default_tags
}

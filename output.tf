output "vpc_id" {
  value = module.network.vpc_id
}
output "private_subnet_ids" {
  value = module.network.public_subnet_private_ids
}
output "public_subnet_ids" {
  value = module.network.public_subnet_public_ids
}
# output "ec2-public-ip" {
#   value = module.ec2instances.ec2-public_ip
# }

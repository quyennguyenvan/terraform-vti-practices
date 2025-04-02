output "vpc_id" {
  description = "The vpc id"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "the vpc cidr block"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_public_ids" {
  description = "the public subnet ids"
  value       = data.aws_subnet_ids.public.ids
}

output "public_subnet_private_ids" {
  description = "the private subnet ids"
  value       = data.aws_subnet_ids.private.ids
}

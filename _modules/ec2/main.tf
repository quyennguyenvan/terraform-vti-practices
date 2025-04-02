resource "aws_key_pair" "this" {
  key_name   = "${var.ec2InstanceName}-vmkey"
  public_key = var.public_key
  tags = merge({
    Name = var.ec2InstanceName
  }, var.default_tags)
}

resource "aws_security_group" "this" {
  name        = "${var.ec2InstanceName}-default-sg"
  description = "default security group"
  vpc_id      = var.vpc_id
  tags = merge({
    Name = "${var.ec2InstanceName}-default-sg" },
  var.default_tags)
}

resource "aws_security_group_rule" "sg-rule-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  ipv6_cidr_blocks  = null
  prefix_list_ids   = null
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "sg-rule-ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  ipv6_cidr_blocks  = null
  prefix_list_ids   = null
  cidr_blocks       = var.trusted_ip_ranges
  security_group_id = aws_security_group.this.id
}

resource "aws_instance" "this" {
  ami           = var.ec2ami
  instance_type = var.ec2InstanceType
  subnet_id     = var.vpc_subnet_id
  #   key_name 
  key_name                    = aws_key_pair.this.key_name
  security_groups             = [aws_security_group.this.id]
  associate_public_ip_address = var.associate_public_ip_address
  tags = merge({
    Name = var.ec2InstanceName
  }, var.default_tags)
}

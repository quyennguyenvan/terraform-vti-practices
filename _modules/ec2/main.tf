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
  for_each          = var.security_group_rule_egress
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  ipv6_cidr_blocks  = null
  prefix_list_ids   = null
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "sg-rule-ingress" {
  for_each = var.security_group_rule_ingress

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  ipv6_cidr_blocks  = null
  prefix_list_ids   = null
  cidr_blocks       = each.value.cidr_blocks
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
  #method 1
  user_data = file(var.userdata)
  #method 2
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum -y install nginx",
      "sudo service nginx start",
      "sudo chkconfig nginx on",
      # "sudo echo 'Welcome to NGINX server' > /usr/share/nginx/html/index.html"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ec2UserConnect
      private_key = file(var.ec2Pemfile)
    }
  }

  tags = merge({
    Name = var.ec2InstanceName
  }, var.default_tags)
}

cidr_block = "10.0.0.0/16"
vpc_name   = "vpcdev"
ec2instances = {
  "vm2" = {
    ec2InstanceName             = "vm2"
    ec2ami                      = "ami-065a492fef70f84b1"
    ec2InstanceType             = "t2.small"
    trusted_ip_ranges           = ["118.70.36.206/32"]
    public_key                  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1vfZuBuxOazU8NU2wBLD4N+rYdkuAypS5A7u6kRp3G nulled@Null.local"
    associate_public_ip_address = true
    ec2Pemfile                  = "/Users/nulled/Library/CloudStorage/OneDrive-Personal/Projects/VTI/demo/terraform_practices/practices_day1/privatekey.pem"
    ec2UserConnect              = "ec2-user"
    # userdata                    = "Users/nulled/Library/CloudStorage/OneDrive-Personal/Projects/VTI/demo/terraform_practices/practices_day1/user-data.yaml"
    security_group = {
      ingress = {
        ssh = {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["118.70.36.206/32"]
        },
        nginx = {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["118.70.36.206/32"]
        }
      }
      egress = {
        ssh = {
          from_port   = 22
          to_port     = 22
          protocol    = "-1"
          cidr_blocks = ["118.70.36.206/32"]
        },

        http = {
          from_port   = 80
          to_port     = 80
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}

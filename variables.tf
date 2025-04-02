
variable "cidr_block" {
  description = "The network CIDR block of VPC"
  default     = "10.0.0.0/16"
}
variable "default_tags" {
  default = {
    created_by       = "Quyen Nguyen",
    created_on       = "2025-03-28",
    last_modified_by = "Quyen Nguyen",
    last_modified_on = "2025-03-28"
  }
}

variable "vpc_name" {
  default = "zzzzzz_naaaaa"
}

variable "ec2instances" {
  default = {
    # "vm1" = {
    #   ec2InstanceName             = "vm1"
    #   ec2ami                      = "ami-065a492fef70f84b1"
    #   ec2InstanceType             = "t2.micro"
    #   trusted_ip_ranges           = ["118.70.36.206/32"]
    #   public_key                  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1vfZuBuxOazU8NU2wBLD4N+rYdkuAypS5A7u6kRp3G nulled@Null.local"
    #   associate_public_ip_address = false
    #   ec2Pemfile                  = "/Users/nulled/Library/CloudStorage/OneDrive-Personal/Projects/VTI/demo/terraform_practices/practices_day1/privatekey.pem"
    #   ec2UserConnect              = "ec2-user"
    # },
    "vm2" = {
      ec2InstanceName             = "vm2"
      ec2ami                      = "ami-065a492fef70f84b1"
      ec2InstanceType             = "t2.small"
      trusted_ip_ranges           = ["118.70.36.206/32"]
      public_key                  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1vfZuBuxOazU8NU2wBLD4N+rYdkuAypS5A7u6kRp3G nulled@Null.local"
      associate_public_ip_address = true
      ec2Pemfile                  = "/Users/nulled/Library/CloudStorage/OneDrive-Personal/Projects/VTI/demo/terraform_practices/practices_day1/privatekey.pem"
      ec2UserConnect              = "ec2-user"
      userdata                    = "Users/nulled/Library/CloudStorage/OneDrive-Personal/Projects/VTI/demo/terraform_practices/practices_day1/user-data.yaml"
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
}

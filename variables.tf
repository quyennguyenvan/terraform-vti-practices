
variable "cidr_block" {
  description = "The network CIDR block of VPC"
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
}

variable "ec2instances" {

}

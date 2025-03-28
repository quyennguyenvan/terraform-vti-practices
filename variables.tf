
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

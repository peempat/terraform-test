variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_session_token" {}
variable "key_name" {}
variable "region" {
  default = "us-east-1"
}
variable "network_address_space" {
  default = "10.0.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.0.1.0/24"
}
variable "subnet2_address_space" {
  default = "10.0.2.0/24"
}
locals {
  resource_prefix = "itKMITL"

  common_tags = {
    itclass = "ipa24"
    itgroup = "year3"
  }
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "subnet_count" {
  default = 2
}

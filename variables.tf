variable "vpc_cidr_ip" {
	description = "VPC supernet base IP address"
	type = "string"
	default = "10.0.0.0"
}

variable "vpc_cidr_mask" {
	description = "VPC supernet netmask"
	default = "16"
}

variable "public_subnet_mask" {
	description = "Netmask of VPC public subnets"
	default = "24"
}

variable "private_subnet_mask" {
	description = "Netmask of VPC private subnets"
	default = "22"
}

variable "region" {
	description = "AWS region for VPC"
	default = "us-west-2"
}

variable "index_to_AZ" {
	description = "Map Terraform 'count' indexes to VPC AZ letters"
	type = "map"
	default = {
		"0" = "a"
		"1" = "b"
		"2" = "c"
	}
}

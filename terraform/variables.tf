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

variable "public_subnet_count" {
	description = "Number of VPC public subnets"
	default = 3
}

variable "private_subnet_mask" {
	description = "Netmask of VPC private subnets"
	default = "22"
}

variable "private_subnet_count" {
	description = "Number of VPC private subnets"
	default = 3
}

variable "data_subnet_mask" {
	description = "Netmask of VPC data subnets"
	default = "24"
}

variable "data_subnet_count" {
	description = "Number of VPC data subnets"
	default = 3
}

variable "region" {
	description = "AWS region for VPC"
	default = "us-west-2"
}

variable "azs" {
	description = "Map Terraform 'count' indexes to VPC AZ letters"
	default = [ "a", "b", "c" ]
}

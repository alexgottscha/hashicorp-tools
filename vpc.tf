resource "aws_vpc" "this" {
	cidr_block = "${format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask)}"
	enable_dns_hostnames = true
	tags {
		Name = "AlexG_VPC"
	}
}

resource "aws_subnet" "public" {
	count = 3
	vpc_id = "${aws_vpc.this.id}"
	cidr_block = "${}"
	cidr_block = "${cidrsubnet(format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask),
									var.public_subnet_mask - var.vpc_cidr_mask, count.index)}"
	availability_zone = "${format("%s%s", var.region, var.azs[count.index%3])}"
}

resource "aws_subnet" "private" {
	count = 3
	vpc_id = "${aws_vpc.this.id}"
	cidr_block = "${}"
	cidr_block = "${cidrsubnet(format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask),
									var.private_subnet_mask - var.vpc_cidr_mask, count.index + aws_subnet.public.count - 1)}"
	availability_zone = "${format("%s%s", var.region, var.azs[count.index%3])}"
}

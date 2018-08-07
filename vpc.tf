resource "aws_vpc" "this" {
	cidr_block = "${format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask)}"
	enable_dns_hostnames = true
	tags {
		Name = "AlexG_VPC"
	}
}

resource "aws_internet_gateway" "public" {
	vpc_id = "${aws_vpc.this.id}"
}

resource "aws_subnet" "public" {
	count = "${var.public_subnet_count}"
	vpc_id = "${aws_vpc.this.id}"
	cidr_block = "${cidrsubnet(format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask),
									var.public_subnet_mask - var.vpc_cidr_mask, count.index)}"
	availability_zone = "${format("%s%s", var.region, var.azs[count.index%3])}"
	map_public_ip_on_launch = true
	tags {
		Name = "${format("%s-%s", "public", var.azs[count.index%3])}"
	}
}

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.this.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.public.id}"
	}
}

resource "aws_route_table_association" "public" {
	count = "${var.public_subnet_count}"
	subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
	route_table_id = "${aws_route_table.public.id}"
}

resource "random_shuffle" "nat_gateway_subnet" {
	input = ["${aws_subnet.public.*.id}"]
	result_count = 1
}

resource "aws_eip" "nat" {
	vpc = true
}

resource "aws_nat_gateway" "private" {
	subnet_id = "${random_shuffle.nat_gateway_subnet.result}"
	association_id = "${aws_eip.nat.id}"
}

resource "aws_subnet" "private" {
	count = "${var.private_subnet_count}"
	vpc_id = "${aws_vpc.this.id}"
	cidr_block = "${cidrsubnet(format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask),
									var.private_subnet_mask - var.vpc_cidr_mask,
									count.index + aws_subnet.public.count - 1)}"
	availability_zone = "${format("%s%s", var.region, var.azs[count.index%3])}"
	tags {
		Name = "${format("%s-%s", "private", var.azs[count.index%3])}"
	}
}

resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.this.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_nat_gateway.private.id}"
	}
}

resource "aws_route_table_association" "private" {
	count = "${var.private_subnet_count}"
	subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
	route_table_id = "${aws_route_table.private.id}"
}

resource "aws_subnet" "data" {
	count = "${var.data_subnet_count}"
	vpc_id = "${aws_vpc.this.id}"
	cidr_block = "${cidrsubnet(format("%s/%s", var.vpc_cidr_ip, var.vpc_cidr_mask),
									var.data_subnet_mask - var.vpc_cidr_mask,
									count.index + aws_subnet.public.count)}"
	availability_zone = "${format("%s%s", var.region, var.azs[count.index%3])}"
	map_public_ip_on_launch = false
	tags {
		Name = "${format("%s-%s", "data", var.azs[count.index%3])}"
	}
}

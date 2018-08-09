data "aws_ami" "openvpnas" {
  most_recent = true
  filter {
    name   = "name"
    values = ["OpenVPN Access Server 2.5.0-fe8020db-5343-4c43-9e65-5ed4a825c931-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]  # Marketplace
}

resource "aws_instance" "openvpnas" {
	tags {
		Name = "OpenVPN AS"
		Role = "openvpnas"
	}
  ami = "${data.aws_ami.openvpnas.id}"
  instance_type = "t2.micro"
	user_data = "file://userdata_openvpnas.sh"
	key_name = "infra"
	subnet_id = "${random_shuffle.openvpnas_subnet.result.0}"
	vpc_security_group_ids = ["${aws_security_group.openvpnas.id}", "${aws_vpc.this.default_security_group_id}"]
}

resource "random_shuffle" "openvpnas_subnet" {
	input = ["${aws_subnet.public.*.id}"]
	result_count = 1
}

resource "aws_security_group" "openvpnas" {
	name = "openvpn_as"
	description = "OpenVPN Access Server"
	vpc_id = "${aws_vpc.this.id}"
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 943
		to_port = 943
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 1194
		to_port = 1194
		protocol = "udp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

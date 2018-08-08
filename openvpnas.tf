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
	}
  ami = "${data.aws_ami.openvpnas.id}"
  instance_type = "t2.micro"
	user_data = "file://userdata_openvpnas.sh"
	key_name = "infra"
	subnet_id = "${random_shuffle.openvpnas_subnet.result.0}"
}

resource "random_shuffle" "openvpnas_subnet" {
	input = ["${aws_subnet.public.*.id}"]
	result_count = 1
}

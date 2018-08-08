provider "aws" {
	region = "${var.region}"
}

resource "aws_key_pair" "alexg" {
	key_name = "alexg"
	public_key = "${file("~/.ssh/id_rsa.pub")}"
}

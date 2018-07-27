# modified from https://www.terraform.io/docs/providers/aws/r/launch_configuration.html

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "drbd_test" {
  name_prefix   = "terraform-drbd_test-"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "drbd_test" {
  name                 = "terraform-drbd_test"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  min_size             = 1
  max_size             = 3

  lifecycle {
    create_before_destroy = false
  }
	user_data = "file://userdata.sh"
}


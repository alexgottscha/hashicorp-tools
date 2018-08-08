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

resource "aws_launch_configuration" "drbd" {
  name_prefix          = "drbd-test-"
  image_id      = "${data.aws_ami.ubuntu.id}"
#	image_id = "ami-1cc69e64"
  instance_type = "t2.micro"
	user_data = "${file("userdata_drbd-test.yml")}"
	key_name = "alexg"
	ebs_block_device {
		volume_type = "standard"
		volume_size = 8
		delete_on_termination = true
		device_name = "/dev/sdf"
	}

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "drbd" {
  name_prefix          = "drbd-test-"
  launch_configuration = "${aws_launch_configuration.drbd.name}"
  min_size             = 1
  max_size             = 3
	vpc_zone_identifier  = ["${aws_subnet.private.*.id}"]

  lifecycle {
    create_before_destroy = true
  }

	tag {
		key = "Name"
		value = "drbd-test"
		propagate_at_launch = true
	}
}


data "aws_ami" "ami_amzn2_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*x86*"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = "${data.aws_ami.ami_amzn2_linux.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${element(aws_subnet.public.*.id, 1)}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
  user_data              = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name  = "${var.environment}-${var.application}-linuxEC2"
    Owner = "${var.owner}"
  }

  volume_tags = {
    Name  = "${var.environment}-${var.application}-linux-volume"
    Owner = "${var.owner}"
  }
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = "${var.default_port}"
    to_port     = "${var.default_port}"
    protocol    = "${var.protocol}"
    cidr_blocks = ["${var.cidr_public}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_public}"]
  }

  tags = {
    Name  = "${var.environment}-${var.application}-allow_http-security_group"
    Owner = "${var.owner}"
  }
}


data "template_file" "user_data" {
  template = "${file("userdata.tpl")}"
}



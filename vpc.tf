provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"

  tags = {
    Name  = "${var.environment}-${var.application}"
    Owner = "${var.owner}"
  }
}





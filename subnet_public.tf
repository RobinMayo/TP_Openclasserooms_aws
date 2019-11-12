#### internet gateway creation
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "${var.environment}-${var.application}"
    Owner = "${var.owner}"
  }
}

#### public subnet creation
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(split(",", var.azs))}"
  cidr_block              = "${cidrsubnet(aws_vpc.vpc.cidr_block, var.netbits, count.index + var.public_networks_prefix)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = {
    Name  = "${var.environment}-${var.application}-public-${count.index + 1}"
    Owner = "${var.owner}"
  }
}

#### public subnet route table creation
resource "aws_route_table" "rtpb" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name  = "${lower("${var.environment}-${var.application}-public-routetable")}"
    Owner = "${var.owner}"
  }
}

resource "aws_route" "routepb" {
  route_table_id         = "${aws_route_table.rtpb.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

#### public subnet route table association
resource "aws_route_table_association" "rtappb" {
  count          = "${length(split(",", var.azs))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.rtpb.id}"
}

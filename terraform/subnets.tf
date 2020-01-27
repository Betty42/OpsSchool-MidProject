resource "aws_subnet" "MidProject-Subnet-Priv" {
  count             = "2"
  availability_zone = "${element(var.azs,count.index)}"
  cidr_block        = "${cidrsubnet(aws_vpc.OpsSchool-MidProject-VPC.cidr_block, 8, count.index)}"
  vpc_id            = "${aws_vpc.OpsSchool-MidProject-VPC.id}"

  tags = {
    Name = "MidProject-Subnet-Priv-${element(var.azs,count.index)}"
  }
}

resource "aws_subnet" "MidProject-Subnet-Pub" {
  count                   = "2"
  availability_zone       = "${element(var.azs,count.index)}"
  cidr_block              = "${cidrsubnet(aws_vpc.OpsSchool-MidProject-VPC.cidr_block,8,count.index + 2)}"
  map_public_ip_on_launch = true ##(understand)
  vpc_id            = "${aws_vpc.OpsSchool-MidProject-VPC.id}"

  tags = {
    Name = "MidProject-Subnet-Pub-${element(var.azs,count.index)}"
  }
}

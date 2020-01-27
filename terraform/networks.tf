# Create Internet GW
resource "aws_internet_gateway" "MidProject-Internet-GW" {
  vpc_id = "${aws_vpc.OpsSchool-MidProject-VPC.id}"

  tags = {
    Name = "MidProject-Internet-GW"
  }
}

# Create EIP for NAT GW
resource "aws_eip" "MidProject-Nat-EIP" {
  count      = "2"
  vpc        = true
  depends_on = ["aws_internet_gateway.MidProject-Internet-GW"]
}

# Create Nat GW
resource "aws_nat_gateway" "MidProject-Nat-GW" {
  count         = "2"
  allocation_id = "${element(aws_eip.MidProject-Nat-EIP.*.id,count.index)}"
  subnet_id     = "${element(aws_subnet.MidProject-Subnet-Pub.*.id,count.index)}"

  tags = {
    Name = "MidProject-NAT-GW-${element(var.azs,count.index)}"
  }

  depends_on = ["aws_eip.MidProject-Nat-EIP"]
}

resource "aws_route_table" "MidProject-Pub-RT" {
  count  = "2"
  vpc_id = "${aws_vpc.OpsSchool-MidProject-VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.MidProject-Internet-GW.id}"
  }

  tags = {
    Name = "MidProject-Pub-RT-${element(var.azs,count.index)}"
  }
}

resource "aws_route_table" "MidProject-Priv-RT" {
  count  = "2"
  vpc_id = "${aws_vpc.OpsSchool-MidProject-VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.MidProject-Nat-GW.*.id,count.index)}"
  }

  tags = {
    Name = "MidProject-Priv-RT-${element(var.azs,count.index)}"
  }
}

resource "aws_route_table_association" "public-association" {
  count          = "2"
  subnet_id      = "${element(aws_subnet.MidProject-Subnet-Pub.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.MidProject-Pub-RT.*.id,count.index)}"
}

resource "aws_route_table_association" "private-association" {
  count          = "2"
  subnet_id      = "${element(aws_subnet.MidProject-Subnet-Priv.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.MidProject-Priv-RT.*.id,count.index)}"
}
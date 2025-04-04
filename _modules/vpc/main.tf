

locals {
  azs               = length(data.aws_availability_zones.available.names)
  current_workspace = terraform.workspace

}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = merge({
    Name = var.vpc_name
  }, var.default_tags)

}

resource "aws_subnet" "public_subnet" {
  depends_on        = [aws_vpc.this]
  count             = local.azs
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.this.id
  tags = merge({
    public-aws_subnet = "true",
    Name              = "public-subnet-${count.index}"
  }, var.default_tags)
}
resource "aws_subnet" "private_subnet" {
  depends_on        = [aws_vpc.this]
  count             = local.azs
  cidr_block        = cidrsubnet(var.cidr_block, 8, local.azs + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.this.id
  tags = merge({
    public-aws_subnet = "false",
    Name              = "private-subnet-${count.index}"
  }, var.default_tags)
}

### Create the resources for public resources
resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.this]
  vpc_id     = aws_vpc.this.id
  tags = merge({
    Name = "IGW-APP",
    ENV  = local.current_workspace
  }, var.default_tags)
}

resource "aws_route" "public_route" {
  depends_on = [
    aws_internet_gateway.igw,
    aws_vpc.this
  ]
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public-route-asssociation" {
  depends_on     = [aws_vpc.this]
  count          = local.azs
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_vpc.this.main_route_table_id
}

### Create the resources for private resources

resource "aws_eip" "eip" {
  depends_on = [aws_vpc.this]
  count      = local.azs
  tags = merge({
    Name = "nat-eip"
  }, var.default_tags)
}
resource "aws_nat_gateway" "private-nat" {
  depends_on = [
    aws_vpc.this,
    aws_eip.eip
  ]
  count         = local.azs
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  tags = merge({
    Name = "nat-gateway"
  }, var.default_tags)
}

resource "aws_route_table" "private-route-table" {
  depends_on = [
    aws_vpc.this,
    aws_nat_gateway.private-nat
  ]
  count  = local.azs
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private-nat.*.id, count.index)
  }
  tags = merge({
    Name = "private-route-table-${count.index}"
  }, var.default_tags)
}

resource "aws_route_table_association" "private-route-table-association" {
  depends_on     = [aws_vpc.this]
  count          = local.azs
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private-route-table.*.id, count.index)
}

### create the resources for database group
resource "aws_db_subnet_group" "db-subnet-group" {
  depends_on = [aws_vpc.this, aws_subnet.private_subnet]
  name       = "${var.vpc_name}-db-subnet-group"
  subnet_ids = data.aws_subnet_ids.private.ids
}

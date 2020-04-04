# Error creating application Load Balancer: ValidationError:
# At least two subnets in two different Availability Zones must be specified

resource "aws_vpc" "coronavirus" {
  cidr_block            = "20.0.0.0/16"
  enable_dns_hostnames  = true

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = "20.0.0.0/24"
  vpc_id            = aws_vpc.coronavirus.id
  availability_zone = "us-east-1a"

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block        = "20.0.1.0/24"
  vpc_id            = aws_vpc.coronavirus.id
  availability_zone = "us-east-1b"

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.coronavirus.id

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id  = aws_route_table.public-route-table.id
  subnet_id       = aws_subnet.public-subnet-1.id
}

resource "aws_internet_gateway" "coronavirus" {
  vpc_id = aws_vpc.coronavirus.id

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_route" "coronavirus-gw-route" {
  route_table_id          = aws_route_table.public-route-table.id
  gateway_id              = aws_internet_gateway.coronavirus.id
  destination_cidr_block  = "0.0.0.0/0"
}

# "Elastic IPs are not supported for load balancers with type 'application'"
# For this reason, there's no point of having an elastic ip and associate it
# with our application load balancer (ALB). ALBs & CLBs are included in the
# free tier but NLBs are not.

# resource "aws_network_interface" "coronavirus" {
#   subnet_id   = aws_subnet.public-subnet-1.id

#   tags = {
#     Name = "Coronavirus EIP"
#   }
# }

# resource "aws_eip" "coronavirus" {
#   vpc                       = true
#   network_interface         = aws_network_interface.coronavirus.id

#   tags = {
#     Name = local.cluster_name
#   }
# }
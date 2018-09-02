

resource "aws_vpc" "vpc-terraform" {
  cidr_block = "10.0.0.0/16"
  tags {
        Name = "terraform-aws-vpc"
  }
}
resource "aws_internet_gateway" "vpc-terraform" {
    vpc_id = "${aws_vpc.vpc-terraform.id}"
}


/*
Public Subnet
*/
resource "aws_subnet" "eu-west-3a-public" {
        vpc_id = "${aws_vpc.vpc-terraform.id}"
        cidr_block = "10.0.0.0/24"
        availability_zone = "eu-west-3a"
        tags {
                Name = "Public Subnet"
        }
}

resource "aws_route_table" "eu-west-3a-public" {
        vpc_id= "${aws_vpc.vpc-terraform.id}"

        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = "${aws_internet_gateway.vpc-terraform.id}"
        }

        tags {
                Name = "Route Public Subnet"
        }
}

resource "aws_route_table_association" "eu-west-3a-public" {
        subnet_id = "${aws_subnet.eu-west-3a-public.id}"
        route_table_id = "${aws_route_table.eu-west-3a-public.id}"
}



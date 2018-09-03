provider "aws" {
     shared_credentials_file = "/root/.aws/credentials"
}



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


/*
Private Subnet
*/

resource "aws_subnet" "terraform-private-subnet" {
    vpc_id = "${aws_vpc.vpc-terraform.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-3b"
    tags {
        Name = "Private Subnet"
    }

}

resource "aws_eip" "nat_eip"{
    vpc = true
}

resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.terraform-private-subnet.id}"
    tags {
        Name = "gw NAT"
    }
}

resource "aws_route_table" "route_private_subnet"{
    vpc_id = "${aws_vpc.vpc-terraform.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw.id}"
    }
}

resource "aws_route_table_association" "association_route_private" {
    subnet_id ="${aws_subnet.terraform-private-subnet.id}"
    route_table_id= "${aws_route_table.route_private_subnet.id}"
}
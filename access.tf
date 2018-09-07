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
        map_public_ip_on_launch = "true"
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
                Name = "Route Public Subnet1"
        }
}

resource "aws_route_table_association" "eu-west-3a-public" {
        subnet_id = "${aws_subnet.eu-west-3a-public.id}"
        route_table_id = "${aws_route_table.eu-west-3a-public.id}"
}

/*
Public Subnet 2
*/


resource "aws_subnet" "eu-west-3b-public" {
        vpc_id = "${aws_vpc.vpc-terraform.id}"
        cidr_block = "10.0.1.0/24"
        availability_zone = "eu-west-3a"
        map_public_ip_on_launch = "true"
        tags {
                Name = "Public Subnet2"
        }
}

resource "aws_route_table" "eu-west-3b-public" {
        vpc_id= "${aws_vpc.vpc-terraform.id}"

        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = "${aws_internet_gateway.vpc-terraform.id}"
        }

        tags {
                Name = "Route Public Subnet"
        }
}

resource "aws_route_table_association" "eu-west-3b-public" {
        subnet_id = "${aws_subnet.eu-west-3b-public.id}"
        route_table_id = "${aws_route_table.eu-west-3b-public.id}"
}



/*
Private Subnet 1
*/

resource "aws_subnet" "terraform-private-subnet1" {
    vpc_id = "${aws_vpc.vpc-terraform.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-3b"
    tags {
        Name = "Private Subnet 1"
    }

}

resource "aws_eip" "nat_eip"{
    vpc = true
}

resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.terraform-private-subnet1.id}"
    tags {
        Name = "gw NAT for subnet1"
    }
}

resource "aws_route_table" "route_private_subnet1"{
    vpc_id = "${aws_vpc.vpc-terraform.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw.id}"
    }
}

resource "aws_route_table_association" "association_route_private1" {
    subnet_id ="${aws_subnet.terraform-private-subnet1.id}"
    route_table_id= "${aws_route_table.route_private_subnet1.id}"
}



/*
Private Subnet 2
*/

resource "aws_subnet" "terraform-private-subnet2" {
    vpc_id = "${aws_vpc.vpc-terraform.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-3c"
    tags {
        Name = "Private Subnet 2"
    }

}

resource "aws_eip" "nat_eip2"{
    vpc = true
}

resource "aws_nat_gateway" "gw2" {
    allocation_id = "${aws_eip.nat_eip2.id}"
    subnet_id = "${aws_subnet.terraform-private-subnet2.id}"
    tags {
        Name = "gw NAT for subnet2"
    }
}

resource "aws_route_table" "route_private_subnet2"{
    vpc_id = "${aws_vpc.vpc-terraform.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.gw2.id}"
    }
}

resource "aws_route_table_association" "association_route_private2" {
    subnet_id ="${aws_subnet.terraform-private-subnet2.id}"
    route_table_id= "${aws_route_table.route_private_subnet2.id}"
}

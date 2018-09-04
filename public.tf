/* 
Web Server
*/

resource "aws_security_group" "sg_web" {
	name = "allow incoming http request"
	description = " allow incoming http request from the outside world "
	vpc_id = "${aws_vpc.vpc-terraform.id}"
	tags {
		Name= "WebServerSG"
	}

	ingress {
		from_port = 80
		to_port   = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

    ingress {
		from_port = 443
		to_port   = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]

	}

	egress {
		from_port = 3306
		to_port = 3306
		protocol = "tcp"
		cidr_blocks = ["10.0.0.0/24"] 
	}
}

resource "aws_instance" "web" {
	ami = "ami-0ebc281c20e89ba4b"
	availability_zone= "eu-west-3a"
	instance_type= "t2.micro"
	key_name = "keysncfparis"
	vpc_security_group_ids = ["${aws_security_group.sg_web.id}"]
	subnet_id= "${aws_subnet.eu-west-3a-public.id}"
	associate_public_ip_address = true 
	tags {
		Name = "Web Server 1"
	}

}


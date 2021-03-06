/* 
Web Server
*/

resource "aws_security_group" "sg_web" {
	name = "WebserverSG"
	description = " allow incoming http request from the outside world "
	vpc_id = "${aws_vpc.vpc-terraform.id}"
	tags {
		Name= "WebServerSG"
	}

	ingress {
		from_port = 80
		to_port   = 80
		protocol = "tcp"
		security_groups = ["${aws_security_group.sg_elb.id}"]
	}

    ingress {
		from_port = 443
		to_port   = 443
		protocol = "tcp"
		security_groups = ["${aws_security_group.sg_elb.id}"]

	}

	ingress {
		from_port = 22
		to_port   = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]

	}

	ingress {
		from_port = 3306
		to_port   = 3306
		protocol = "tcp"
		security_groups = ["${aws_security_group.allow_sql.id}"]
	}	

	egress {
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web1" {
	ami = "ami-05e4e68905123e3b0"
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


resource "aws_instance" "web2" {
	ami = "ami-05e4e68905123e3b0"
	availability_zone= "eu-west-3b"
	instance_type= "t2.micro"
	key_name = "keysncfparis"
	vpc_security_group_ids = ["${aws_security_group.sg_web.id}"]
	subnet_id= "${aws_subnet.eu-west-3b-public.id}"
	associate_public_ip_address = true 
	tags {
		Name = "Web Server 2"
	}

}


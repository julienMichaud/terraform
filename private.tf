/*
Database Server with RDs service
*/

resource "aws_security_group" "allow_sql" {
	name = "allow incoming sql request"
	description = " allow incoming sql request from the public subnet "
	vpc_id = "${aws_vpc.vpc-terraform.id}"
	ingress {
		from_port = 3306
		to_port   = 3306
		protocol = "tcp"
		security_groups = ["${aws_security_group.sg_web.id}"]
	}

	egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
		Name= "MySQLSG"
	}

}

resource "aws_db_subnet_group" "private_subnet" {
	name= "private_subnet"
	subnet_ids = ["${aws_subnet.terraform-private-subnet1.id}" , "${aws_subnet.terraform-private-subnet2.id}"]

}


resource "aws_db_instance" "mariadb" {
	engine = "mariadb" 
	instance_class = "db.t2.micro"
	allocated_storage = 20
	engine_version = "10.2.12"
	availability_zone = "eu-west-3b"
	name = "base_de_donnee"
    username = "julien"
    password = "password"
	storage_type = "standard"
	db_subnet_group_name = "${aws_db_subnet_group.private_subnet.id}" 
	vpc_security_group_ids = ["${aws_security_group.allow_sql.id}"]

}



resource "aws_security_group" "sg_elb" {
  name = "sg_elb"
  description = " allow incoming http request from the outside world "
  vpc_id = "${aws_vpc.vpc-terraform.id}"
  tags {
    Name= "elbSG"
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
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_elb" "elb" {
  name = "terraform-ELB"
  security_groups = ["${aws_security_group.sg_elb.id}"]
  subnets = ["${aws_subnet.eu-west-3a-public.id}"]
  instances = ["${aws_instance.web1.id}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}







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


resource "aws_alb" "alb" {
  name = "terraform-ELB"
  internal = false 
  security_groups = ["${aws_security_group.sg_elb.id}"]
  subnets = ["${aws_subnet.eu-west-3a-public.id}", "${aws_subnet.eu-west-3b-public.id}"]
  
}

resource "aws_alb_target_group" "alb_front_http" {
  name  = "alb-front-https"
  vpc_id  = "${aws_vpc.vpc-terraform.id}"
  port  = "80"
  protocol  = "HTTP"
  health_check {
    path = "/index.php"
    port = "80"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    timeout = 4
    matcher = "200-308"
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_front_http.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group_attachment" "alb_backend-01_http" {
  target_group_arn = "${aws_alb_target_group.alb_front_http.arn}"
  target_id        = "${aws_instance.web1.id}"
  port             = 80
}

resource "aws_alb_target_group_attachment" "alb_backend-02_http" {
  target_group_arn = "${aws_alb_target_group.alb_front_http.arn}"
  target_id        = "${aws_instance.web2.id}"
  port             = 80
}


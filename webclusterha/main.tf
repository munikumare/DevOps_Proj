provider "aws" {
	region = "us-east-1"
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "agterrafrom" {
	launch_configuration = "${aws_launch_configuration.lcterraform.id}"
	availability_zones = ["${data.aws_availability_zones.all.names}"]

	min_size = 2
	max_size = 5

	load_balancers = ["${aws_elb.elbterraform.name}"]
	health_check_type = "ELB"

	tag {
	 key = "Name"
	 value = "terraformautoscaling"
	 propagate_at_launch = true

     }
}

resource "aws_launch_configuration" "lcterraform" {
	image_id = "ami-6d1c2007"
        instance_type = "t2.micro"
        security_groups = ["${aws_security_group.sgterraform.id}"]
        key_name = "admin1"
        user_data = "${file("smallscript")}"
    
	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_security_group" "sgterraform" {
	name = "tfrm-sg-clstr"

        ingress {
                from_port = "22"
                to_port   = "22"
                protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
        ingress {
                from_port = "80"
                to_port   = "80"
                protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
        ingress {
                from_port = "443"
                to_port   = "443"
               protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
        egress {
                from_port = "0"
                to_port = "1000"
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
               }
	lifecycle {
		create_before_destroy = true
	}	
}

resource "aws_elb" "elbterraform" {
	name = "terraform-elb"
	security_groups = ["${aws_security_group.sgelbterraform.id}"]
	availability_zones = ["${data.aws_availability_zones.all.names}"]
	
	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 10
		timeout = 3
		interval = 30
	#	target = "HTTP:80/index.html"
		target = "HTTPS:${var.healthchk_port}/index.html"
	}

	listener {
		lb_port = 80
		lb_protocol = "http"
		instance_port = "80"
		instance_protocol = "http"
	}
	listener {
         lb_port = 443
          lb_protocol = "https"
           instance_port = "443"
           instance_protocol = "https"
        ssl_certificate_id = "arn:aws:acm:us-east-1:211402125947:certificate/bfda15fc-5561-4a76-82bc-83a4c64e34dd"
	
	}

}

resource "aws_security_group" "sgelbterraform" {
	name = "terraform-sg-elb"
	egress {
   		 from_port = 0
    		to_port = 0
    		protocol = "-1"
   		 cidr_blocks = ["0.0.0.0/0"]
  	}
	
	ingress {
                from_port = "80"
                to_port   = "80"
                protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
       ingress {
        from_port = "443"
        to_port   = "443"
        protocol  = "tcp"
        cidr_blocks= ["0.0.0.0/0"]
        }

}


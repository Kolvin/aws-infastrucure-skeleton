// Application Load Balancer
resource "aws_alb" "app-lb" {
  name                        = "${var.alb_name}"
  subnets                     = ["${data.terraform_remote_state.vpc.public_subnet_list}"]
  security_groups             = ["${data.terraform_remote_state.vpc.http_access_sg}"]
  enable_deletion_protection  = "${var.enable_deletion_protection}"
  internal                    = false

  tags {
    Name = "${var.alb_name}-${count.index}"
    Service_Name  = "${var.alb_name}-${count.index}"
    Creator       = "Terraform"
    Environment   = "Prod"
    Product       = "DevOps"
  }
}

// LB SSL Listener
resource "aws_alb_listener" "ssl" {
  load_balancer_arn = "${aws_alb.app-lb.arn}"
  port              = "${var.backend_port}"
  protocol          = "${var.backend_protocol}"
  ssl_policy        = "${var.ssl_security_policy}"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.prod-app-tg.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb.app-lb"]
}


// ---------------- STAGING APP ----------------
resource "aws_alb_target_group" "prod-app-tg" {
  name                 = "prod-app-tg"
  port                 = "${var.backend_port}"
  protocol             = "${upper(var.backend_protocol)}"
  vpc_id               = "${data.terraform_remote_state.vpc.vpc_id.0}"
  deregistration_delay = "${var.deregistration_delay}"
  target_type          = "${var.target_type}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.cookie_duration}"
    enabled         = "${ var.cookie_duration == 1 ? false : true}"
  }

  depends_on = ["aws_alb.app-lb"]
}

// Prod App Instances
resource "aws_lb_target_group_attachment" "prod-app-instances" {
  count            = "${var.instance_count}"
  target_group_arn = "${aws_alb_target_group.prod-app-tg.arn}"
  target_id        = "${element(aws_instance.prod-app.*.id, count.index)}"
  port             = 80

  depends_on = ["aws_alb_target_group.prod-app-tg"]
}

// Prod Domain Listener Rule
resource "aws_lb_listener_rule" "prod_app_host_routing" {
  listener_arn = "${aws_alb_listener.ssl.arn}"
  priority = 1

  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.prod-app-tg.arn}"
  }

  condition {
    field = "host-header"
    values = ["app.com"]
  }
}
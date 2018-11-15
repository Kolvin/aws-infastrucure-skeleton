resource "aws_security_group" "allow_redis_access" {
  name        = "allow_redis_access"
  description = "Allow redis access"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_redis_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "allow_db_access" {
  name        = "allow_db_access"
  description = "Allow db access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    // Home Ip in here along with VPC range
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_db_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "http_access" {
  name        = "allow_http_access"
  description = "Allow HTTP access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "http_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "restrict_instance_access" {
  name        = "allow_http_access_via_alb"
  description = "Allow HTTP access via ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.http_access.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "restricted_http_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "allow_engineers_ssh" {

  name        = "allow_engineers_ssh"
  description = "Allow Engineers access to port 22"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // change to whitelist IP CDIR blocks of you want to restrict ssh location
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_engineers_ssh"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "allow_custom_ssh_access" {
  name        = "allow_custom_ssh_access"
  description = "Allow custom access to port 222"

  ingress {
    from_port   = 222
    to_port     = 222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_custom_ssh_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

// Metrics SG
resource "aws_security_group" "allow_grafana_access" {
  name        = "allow_grafana_ssh"
  description = "Allow grafana access to port 3000"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_grafana_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "allow_alertmanager_access" {
  name        = "allow_alertmanager_ssh"
  description = "Allow alertmanager access to port 9093"

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_alertmanager_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "allow_prometheus_access" {
  name        = "allow_prometheus_ssh"
  description = "Allow prometheus access to port 9090 and 9100"

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_prometheus_access"
  }

  vpc_id = "${module.vpc.vpc_id}"
}
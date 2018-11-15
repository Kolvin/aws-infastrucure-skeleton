output "public_subnet_list" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_subnet_list" {
  value = ["${module.vpc.private_subnets}"]
}

output "vpc_id" {
  value = ["${module.vpc.vpc_id}"]
}

output "vpc_cidr" {
  value = ["${module.vpc.vpc_cidr_block}"]
}

output "allow_prometheus_access_sg" {
  value = "${aws_security_group.allow_prometheus_access.id}"
}

output "allow_alertmanager_access_sg" {
  value = "${aws_security_group.allow_alertmanager_access.id}"
}

output "http_access_sg" {
  value = "${aws_security_group.http_access.id}"
}

output "resirtcted_access_sg" {
  value = "${aws_security_group.restrict_instance_access.id}"
}


output "allow_db_access_sg" {
  value = "${aws_security_group.allow_db_access.id}"
}

output "allow_grafana_access_sg" {
  value = "${aws_security_group.allow_grafana_access.id}"
}


output "allow_engineers_access_sg" {
  value = "${aws_security_group.allow_engineers_ssh.id}"
}


output "allow_custom_ssh_access_sg" {
  value = "${aws_security_group.allow_custom_ssh_access.id}"
}
// Infastructure State Managment | s3
terraform {
  backend "s3" {
    profile        = "default"
    bucket         = "terraform.company"
    dynamodb_table = "terraform-locking"
    key            = "product/staging/shared/ec2/terraform.tfstate"
    region         = "eu-west-1"
  }
}

// EC2 Instance Managment
resource "aws_instance" "staging-app" {

  ami = "${var.base_ami}" // BASE AMI FROM PACKER BUILD
  instance_type = "${var.instance_type}"
  count = "${var.instance_count}"
  key_name = "${var.key_name}"

  subnet_id  = "${data.terraform_remote_state.vpc.public_subnet_list.0}"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.resirtcted_access_sg}",
    "${data.terraform_remote_state.vpc.allow_engineers_access_sg}",
    "${data.terraform_remote_state.vpc.allow_grafana_access_sg}",
    "${data.terraform_remote_state.vpc.allow_alertmanager_access_sg}",
    "${data.terraform_remote_state.vpc.allow_prometheus_access_sg}",
  ]

  // run sh scripts
  user_data = "${data.template_cloudinit_config.configuration.rendered}"

  // Switch this if using ALB
  associate_public_ip_address = false

  // AWS tags for filtering
  tags {
    Name = "app-staging-${count.index}"
    Service_Name  = "app-staging-${count.index}"
    Creator       = "Terraform"
    Environment   = "Staging"
    Product       = "DevOps"
  }
}

// Bastion Host
resource "aws_instance" "staging-bastion" {

  ami = "${var.base_ami}"
  count = 1
  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  subnet_id  = "${data.terraform_remote_state.vpc.public_subnet_list.0}"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.allow_engineers_access_sg}",
    "${data.terraform_remote_state.vpc.allow_grafana_access_sg}",
    "${data.terraform_remote_state.vpc.allow_alertmanager_access_sg}",
    "${data.terraform_remote_state.vpc.allow_prometheus_access_sg}",
  ]

  // run sh scripts
  user_data = "${data.template_cloudinit_config.configuration.rendered}"


  // AWS tags for filtering
  tags {
    Name = "Staging App Bastion"
    Service_Name  = "staging-bastion-${count.index}"
    Creator       = "Terraform"
    Environment   = "Staging"
    Product       = "DevOps"
  }
}

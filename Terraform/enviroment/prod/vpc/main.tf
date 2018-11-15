// VPC State Managment | s3
terraform {
  backend "s3" {
    bucket         = "terraform.company"
    key            = "product/prod/vpc/terraform.tfstate"
    dynamodb_table = "terraform-locking"
    region         = "eu-west-1"
    profile	       = "default"
  }
}

// Module to handle VPC config!
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"
  name = "prod_product_vpc"

  enable_dns_hostnames = true

  cidr = "${var.cdirPrefix}.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1c"]
  private_subnets = ["${var.cdirPrefix}.1.0/24", "${var.cdirPrefix}.3.0/24"]
  public_subnets  = ["${var.cdirPrefix}.101.0/24", "${var.cdirPrefix}.103.0/24"]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = false

  tags = {
    Service_Owner = "DevOps"
    Service_Name  = "Prod"
    Product       = "VPC"
    Creator       = "Terraform"
  }
}

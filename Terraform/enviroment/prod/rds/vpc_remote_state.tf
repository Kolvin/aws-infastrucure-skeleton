// VPC State Managment | s3
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket         = "terraform.company"
    key            = "product/staging/vpc/terraform.tfstate"
    dynamodb_table = "terraform-locking"
    region         = "${var.region}"
    profile        = "${var.profile}"
  }
}

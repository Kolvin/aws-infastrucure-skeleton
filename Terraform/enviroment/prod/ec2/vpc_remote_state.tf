data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket         = "terraform.company"
    key            = "staging/staging/vpc/terraform.tfstate"
    dynamodb_table = "terraform-locking"
    region         = "${var.region}"
    profile        = "${var.profile}"
  }
}
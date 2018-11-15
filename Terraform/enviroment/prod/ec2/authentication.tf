// AWS Authentication
provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}
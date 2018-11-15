// RDS Remote State
terraform {
  backend "s3" {
    bucket         = "terraform.company"
    key            = "staging/shared/rds/terraform.tfstate"
    dynamodb_table = "terraform-locking"
    region         = "eu-west-1"
    profile	       = "default"
  }
}

#####
# DB
#####
module "app-staging-db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds/"

  identifier = "staging-app-db"

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  name     = "staging-app-db"
  username = "AppStaging"
  password = "79pUHMk9CHCbrhQR"
  port     = "3306"

  iam_database_authentication_enabled = true
  apply_immediately = true
  publicly_accessible = false

  vpc_security_group_ids = [
    "${data.terraform_remote_state.vpc.allow_db_access_sg}"
  ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  // AWS tags for filtering
  tags = {
    Name = "app-staging-DB"
    Service_Name  = "App-staging-db"
    Creator       = "Terraform"
    Environment   = "Staging"
    Product       = "DevOps"
  }

  # DB subnet group
  subnet_ids = "${data.terraform_remote_state.vpc.private_subnet_list}"

  # DB parameter group
  family = "mysql5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "Staging-App-Snapshot"

  create_db_option_group = false
}
// *** Auth Var ***
variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  default = "default"
}

// *** EC2 CONFIG ****
variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t2.small"
}

variable "base_ami" {
  default = "ami-05af7fe57c341ead5"
}

variable "key_name" {
  default = 'YourKeyName'
}





//  *** Load Balancing Application ***
// Target Group config
variable "alb_name" {
  default = "staging-app-alb"
}


// SSL HANDLED BY ALB
variable "backend_port" {
  default = "443"
}

variable "backend_protocol" {
  default = "HTTPS"
}

variable "deregistration_delay" {
  default = 300
}

variable "target_type" {
  default = "instance"
}

variable "cookie_duration" {
  default = 86400
}

variable "enable_deletion_protection" {
  default = false
}
// Target Group config

variable "ssl_security_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  default = "arn:aws:acm:eu-west-1:123123"
}
output "staging_app_instance_ids" {
  value = ["${aws_instance.prod-app.*.id}"]
}

output "bastion_instance_ids" {
  value = ["${aws_instance.prod-bastion.*.id}"]
}
output "staging_app_instance_ids" {
  value = ["${aws_instance.staging-app.*.id}"]
}

output "bastion_instance_ids" {
  value = ["${aws_instance.staging-bastion.*.id}"]
}
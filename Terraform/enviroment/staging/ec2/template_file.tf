// Set Host Name SH Script
data "template_file" "hostname" {
  template = "${file("${path.module}/user_data/set_hostname.sh")}"
  count    = 1

  vars {
    hostname = "app-staging-${count.index}"
  }
}

// Instance Module installs
data "template_file" "server-module-installs" {
  template = "${file("${path.module}/user_data/server_provisions.sh")}"
}


// Master call
data "template_cloudinit_config" "configuration" {
  "part" {
    content = "${element(data.template_file.hostname.*.rendered, count.index)}"
  }

  "part" {
    content = "${data.template_file.server-module-installs.rendered}"
  }
}
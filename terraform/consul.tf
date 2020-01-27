#create the consul cluster resources#

resource "aws_instance" "midproject_consul_server" {
  count = 3
  ami   = "ami-024582e76075564db"
  subnet_id = "${element(aws_subnet.MidProject-Subnet-Pub.*.id,count.index)}"
  instance_type = "t2.micro"
  key_name = var.key_name
  user_data = "${element(data.template_file.user_data_server.*.rendered, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.midproject-consul-sg.id}"]
    
  tags = {
    Name = "midproject_consul_server_${count.index+1}"
    consul_server = "true"
  }
}

resource "aws_instance" "midproject_consul_master" {
  count = 1
  ami   = "ami-024582e76075564db"
  subnet_id = "${element(aws_subnet.MidProject-Subnet-Priv.*.id,count.index)}"
  instance_type = "t2.micro"
  key_name = var.key_name
  user_data = "${data.template_cloudinit_config.master.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.midproject-consul-sg.id}"]
    
  tags = {
    Name = "midproject_consul_master"
    consul_server = "true"
  }
}

data "template_file" "user_data_server" {
  count = 2
  template = file("${path.module}/templates/user_data_server.sh")
  vars = {
    consul_version = "${var.consul_version}"
    config = <<EOF
      "node_name": "midproject_consul_server_${count.index+1}",
      "server": true,
      "bootstrap_expect": 3,
      "ui": true
    EOF
  }
}

data "template_file" "user_data_application" {
  template = file("${path.module}/templates/user_data_server.sh")
  vars = {
    consul_version = "${var.consul_version}"
    config = <<EOF
      "node_name": "midproject_consul_master",
      "server": false,
      "enable_script_checks": true
    EOF
  }
}

data "template_file" "webserver_registration" {
  template = file("${path.module}/templates/webserver_registration.sh")
  vars = {
    consul_version = "${var.consul_version}"
  }
}

data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

 part {
   content_type = "text/x-shellscript"
   content      = "${data.template_file.user_data_application.rendered}"
 }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.webserver_registration.rendered}"
  }
}

# OUTPUTS #

output "consul_server" {
  value = ["${aws_instance.midproject_consul_server.*.public_ip}"]
}

output "application_server" {
  value = ["${aws_instance.midproject_consul_master.*.public_ip}"]
}


output "consul_server" {
  value = ["${aws_instance.midproject_consul_server.*.public_ip}"]
}

output "application_server" {
  value = ["${aws_instance.midproject_consul_master.*.public_ip}"]
}


output "jenkins_master" {
  value = ["${aws_instance.midproject-Jenkins-Master-Pub.*.public_ip}"]
}

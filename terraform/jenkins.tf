data "template_file" "ansible_registration" {
  template = file("${path.module}/ansible/ansible_init.sh")
}

data "template_file" "jenkins_registration" {
  template = file("${path.module}/ansible/jenkins_install.sh")
}

# Create AWS Public Ubuntu instance with Jenkins
resource "aws_instance" "midproject-Jenkins-Master-Pub" {
  count = 1
  ami   = "ami-024582e76075564db"
  instance_type               = "t2.micro"
  subnet_id = "${element(aws_subnet.MidProject-Subnet-Pub.*.id,count.index)}"
  associate_public_ip_address = true
  key_name = var.key_name
  vpc_security_group_ids = ["${aws_security_group.midproject_jenkins_sg.id}"]
  user_data = "${data.template_file.jenkins_registration.rendered}"

  tags = {
    Name   = "midproject-Jenkins-Master-Pub"
  }
  depends_on = ["aws_instance.midproject_jenkins_slave"]
}

resource "aws_instance" "midproject_jenkins_slave" {
  count = 1
  ami   = "ami-024582e76075564db"
  instance_type               = "t2.micro"
  subnet_id = "${element(aws_subnet.MidProject-Subnet-Priv.*.id,count.index)}"
  associate_public_ip_address = true
  key_name = var.key_name
  vpc_security_group_ids = ["${aws_security_group.midproject_jenkins_sg.id}"]
  user_data = "${data.template_file.ansible_registration.rendered}"

  tags = {
    Name  = "midproject-Jenkins-Slave-Priv"
  }
}

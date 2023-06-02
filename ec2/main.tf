#below line is for ansile image
data "aws_caller_identity" "current" {}

data "aws_ami" "ami" {
 most_recent = true
 name_regex  = "Devops-practice-with-ansible"
 owners      = [data.aws_caller_identity.current.account_id]
}


resource "aws_instance" "ec2" {
  ami                     = data.aws_ami.ami.id 
  instance_type           = var.instance_type
  vpc_security_group_ids  = [var.sg_id]

  tags = {
     Name = var.component
 }
} 

resource "null_resource" "provisioner" {
  provisioner "remote-exec" {
    connection {
      host     = aws_instance.ec2.public_ip
      user     = "centos"
      password = "DevOps321"
    }

    inline = [
      "ansible-pull -i localhost, -U https://github.com/prasannagunda1806/roboshop-terraform-infra.git roboshop.yml -e role_name=${var.component}",
    ]
  }
}




 variable "instance_type" {
     type = string
 }
 variable "component" {
     type = string
 }
 variable "sg_id" {}
 
 output "private_ip" {
     value = aws_instance.ec2.private_ip
 }
 
 
 
 
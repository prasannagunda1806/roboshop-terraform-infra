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
  iam_instance_profile    = "${var.env}-{var.component}-role"

  tags = {
     Name = var.component
 }
} 

 # resource "null_resource" "provisioner" {
 #  provisioner "remote-exec" {
 #     connection {
 #       host     = aws_instance.ec2.public_ip
 #       user     = "centos"
 #       password = "DevOps321"
 #     }

 #     inline = [
 #       "ansible-pull -i localhost, -U https://github.com/prasannagunda1806/learn-ansible.git roboshop.yml -e role_name=${var.component}",
 #     ]
 #   }
 # }
resource "aws_iam_policy" "ssm-policy" {
  name        = "${var.env}.${var.component}-ssm"
  path        = "/"
  description = "${var.env}.${var.component}-ssm"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters",
                "ssm:GetParameterHistory",
                "ssm:GetParameters",
                "ssm:GetPatchBaseline"
            ],
            "Resource": "*"
        }
    ]
}

resource "aws_iam_role" "role" {
  name = "${var.env}.${var.component}-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  })

resource "aws_iam_instance_profile" "profile" {
  name = "${var.env}.${var.component}-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.ssm-policy.arn
}
 variable "instance_type" {
     type = string
 }
 variable "component" {
     type = string
 }
 variable "sg_id" {}
 variable "env" {}
 
 output "private_ip" {
     value = aws_instance.ec2.private_ip
 }
 
 
 
 
 
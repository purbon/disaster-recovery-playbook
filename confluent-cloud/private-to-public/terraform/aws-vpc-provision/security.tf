resource "aws_security_group" "ssh" {
  description = "Managed by Terraform"
  name = "${var.ownershort}-ssh"

  vpc_id = aws_vpc.bootcamp_cemea.id

  # ssh from anywhere
  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jumphost" {
  description = "Jumphost - Managed by Terraform"
  name = "${var.ownershort}-jumphost"

  tags = {
    Name = "${var.ownershort}-jumphost"
    Owner_Name = var.Owner_Name
    Owner_Email = var.Owner_Email
  }

  vpc_id = aws_vpc.bootcamp_cemea.id

   # cluster
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  dynamic "ingress" {
    for_each = local.myip-cidrs
    content {
      from_port   = 9092
      to_port     = 9092
      protocol    = "tcp"
      description = "Jumphost access from within VPC"
      cidr_blocks = [aws_vpc.bootcamp_cemea.cidr_block, "${ingress.value}"]
    }
  }

  dynamic "ingress" {
    for_each = local.myip-cidrs
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Jumphost access from within VPC"
      self = true
      cidr_blocks = [aws_vpc.bootcamp_cemea.cidr_block, "${ingress.value}"]
    }
  }

  dynamic "ingress" {
    for_each = local.myip-cidrs
    content {
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      description = "Kibana access from within VPC"
      cidr_blocks = [aws_vpc.bootcamp_cemea.cidr_block, "${ingress.value}"]
    }
  }
}

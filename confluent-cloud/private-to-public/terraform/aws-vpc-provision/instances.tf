resource "aws_instance" "jump-host" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.jumphost-instance-type
  subnet_id         = element(aws_subnet.bootcamp_cemea, count.index).id
  availability_zone = element(var.azs, count.index)
  # security_groups = ["${var.security_group}"]
  vpc_security_group_ids = [aws_security_group.jumphost.id, aws_security_group.ssh.id]
  key_name = var.key_name
  root_block_device {
    volume_size = 1000 # 1TB
  }
  tags = {
    Name = "${var.ownershort}-jumphost-${count.index}-${element(var.azs, count.index)}"
    description = "Jumphost nodes - Managed by Terraform"
    nice-name = "jumphost-${count.index}"
    nodeId = count.index
    role = "jumphost"
    Owner_Name = var.Owner_Name
    Owner_Email = var.Owner_Email
    sshUser = "ubuntu"
    # sshPrivateIp = true // this is only checked for existence, not if it's true or false by terraform.py (ati)
    createdBy = "terraform"
    # ansible_python_interpreter = "/usr/bin/python3"
    #EntScheduler = "mon,tue,wed,thu,fri;1600;mon,tue,wed,thu;fri;sat;0400;"
    region = var.region
    #role_region = "brokers-${var.region}"
  }
}
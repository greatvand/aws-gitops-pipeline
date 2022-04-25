//aws ec2 describe-images --image-ids ami-053ac55bdcfe96e85
data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
} //terraform state show data.aws_ami.server_ami

resource "aws_key_pair" "main_key" {
  key_name   = "main_key"
  public_key = file("/home/ubuntu/.ssh/mainkey.pub")
}

resource "aws_instance" "main_ec2" {
  count                  = var.main_instance_count
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.main_key.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  subnet_id              = aws_subnet.public_subnet[count.index].id
  root_block_device {
    volume_size = 8
  }

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sed -i '/^[0-9]/d' aws_hosts"
  }
}
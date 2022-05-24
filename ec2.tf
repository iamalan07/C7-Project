#### cat bastionec2.tf
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "raahul-key"
  vpc_security_group_ids = [aws_security_group.ingress-all-test.id]
  subnet_id = module.vpc.public_subnets[0]
 tags = {
    Name = "Bastion"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  vpc      = true
}

### cat jenkinsec2.tf
data "aws_ami" "ubuntu2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu2.id
  instance_type = "t2.micro"
  key_name      = "raahul-key"
  vpc_security_group_ids = [aws_security_group.ingress-all.id]
  subnet_id = module.vpc.private_subnets[0]
 tags = {
    Name = "Jenkins"
  }
}
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  vpc      = true
}

### cat appec2.tf
data "aws_ami" "ubuntu1" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu1.id
  instance_type = "t2.micro"
  key_name      = "raahul-key"
  vpc_security_group_ids = [aws_security_group.ingress-all-sg.id]
  subnet_id = module.vpc.private_subnets[1]
 tags = {
    Name = "AppServer"
  }
}
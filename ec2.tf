# 1. Register your local SSH Public Key with AWS
resource "aws_key_pair" "deployer_key" {
  key_name   = "monitoring-project-key"
  public_key = file("${path.module}/monitoring_key.pub")
}

# 2. Fetch the latest official Ubuntu 22.04 LTS Amazon Machine Image (AMI)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Official Canonical (Ubuntu) AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 3. Provision the EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro" # Fits nicely in the AWS Free Tier
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.deployer_key.key_name

  # Allocate a solid block of storage for our container logs and metrics
  root_block_device {
    volume_size           = 20 # 20 GB Storage
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "monitoring-project-server"
  }
}
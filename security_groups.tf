resource "aws_security_group" "ec2_sg" {
  name        = "monitoring-project-sg"
  description = "Allow inbound traffic for SSH, Web, and Monitoring"
  vpc_id      = aws_vpc.main.id

  # 1. SSH Access (For Ansible configuration)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # 2. HTTP Access (For Nginx Web Server)
  ingress {
    description = "HTTP Web Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 3. HTTPS Access (For Let's Encrypt SSL)
  ingress {
    description = "HTTPS Secured Web Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 4. Grafana Dashboard Access
  ingress {
    description = "Grafana Web UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 5. Outbound Rules (Allow the server to talk to the internet)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means ALL protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monitoring-project-sg"
  }
}
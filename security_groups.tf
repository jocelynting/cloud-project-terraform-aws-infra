resource "aws_security_group" "webapp_sg" {
  name        = "WebApp-SecurityGroup"
  description = "Allow public access to WebApp"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow HTTP access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebApp-SecurityGroup"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "Database-SecurityGroup"
  description = "Allow WebApp EC2 to access MySQL"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "Allow MySQL from WebApp"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webapp_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database-SecurityGroup"
  }
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Allow VPC Endpoint(CloudWatch) access to VPC"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPCEndpoint-SecurityGroup"
  }
}

resource "aws_security_group" "nlb_sg" {
  name        = "nlb-sg"
  description = "NLB Security Group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NLB-SecurityGroup"
  }
}
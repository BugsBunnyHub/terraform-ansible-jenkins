#LB
resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "Allow 443 to Jenkins SG"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow 443 from anywhere"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow 80 from anywhere"
  }
  egress {
    from_port = 0
    # -1 stands for all protocols
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# jenkins master
resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "Allow 8080 and 22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    from_port       = 8080
    protocol        = "tcp"
    to_port         = 8080
    security_groups = [aws_security_group.lb-sg.id]
    description     = "Allow 8080"
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.external_ip]
  }
  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/1"]
  }
}

# jenkins slave
resource "aws_security_group" "jenkins-sg-oregon" {
  provider    = aws.region-worker
  name        = "jenkins-sg-oregon"
  description = "Allow 22"
  vpc_id      = aws_vpc.vpc_master_oregon.id
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.external_ip]
  }
  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

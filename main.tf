############################
#VPC BLOCK
############################
resource "aws_vpc" "devops_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops_vpc"
  }
}
##########################
#SUBNET BLOCK
#######################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    name = "devops-public-subnet"
  }
}
##################
#INTERNET GATEWAY
#################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-igw"
  }
}
#####################
#Route table
#############
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route"
  }
}
##############################
#ROUTE ASSOCIATION
#############################
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
########################
#Security Group
########################
resource "aws_security_group" "ec2_sg" {
  name   = "allow-ssh-http"
  vpc_id = aws_vpc.devops_vpc.id

  ingress {
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
}
##############################
#IAM ROLES 
##############################
resource "aws_iam_role" "ssm_role2" {

  name = "ec2-ssm-role2"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [{

      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"

    }]

  })
}
########################
#ATTACH SSM POLICY 
#########################
resource "aws_iam_role_policy_attachment" "ssm_policy" {

  role = aws_iam_role.ssm_role2.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}
###################################
#INSTANCE PROFILE 
##################################
resource "aws_iam_instance_profile" "profile" {

  name = "ec2-ssm-profile"

  role = aws_iam_role.ssm_role2.name

}
########################
#EC2 INSTANCE 1
########################
resource "aws_instance" "ubuntu_server" {
  ami                    = var.ami_ubuntu
  instance_type          = var.instance1_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.profile.name

  tags = {
    Name = "Ubuntu-Server"
  }
}
################################
#EC2 INSTANCE 2
################################
resource "aws_instance" "linux_server" {
  ami                    = var.ami_amazon_linux
  instance_type          = var.instance2_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  tags = {
    Name = "Amazon-Linux-Server"
  }
}
###############################
#CREATE IAM USER
###############################
# IAM USER
##############################

resource "aws_iam_user" "devops_user" {
  name = var.username
}

###################################
# IAM POLICY FOR USER
##############################

resource "aws_iam_user_policy" "ec2_access" {

  name = "ec2-access-policy"

  user = aws_iam_user.devops_user.name

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [{

      Effect = "Allow"

      Action = [
        "ec2:*",
        "ssm:*"
      ]

      Resource = "*"

    }]

  })
}
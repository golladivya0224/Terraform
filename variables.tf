variable "aws_region" {
  description = "AWS REGION"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}
variable "subnet_cidr" {
  description = "SUBNET CIDR"
  default     = "10.0.0.0/24"
}
variable "instance1_type" {
  default = "t3.micro"
}
variable "instance2_type" {
  default = "t3.small"
}
variable "ami_ubuntu" {
  description = "UBUNTU AMI"
  default = "ami-0c7217cdde317cfec"

}
variable "ami_amazon_linux" {
  description = "AMAZON AMI LINUX"
  default = "ami-023c11a32b0207432"
}
variable "username" {
  default = "devops-user"
}


output "vpc_id" {


  value = aws_vpc.devops_vpc.id


}



output "ubuntu_instance_id" {


  value = aws_instance.ubuntu_server.id


}



output "amazon_linux_instance_id" {


  value = aws_instance.linux_server.id


}



output "private_ip_ubuntu" {


  value = aws_instance.ubuntu_server.private_ip


}



output "private_ip_linux" {


  value = aws_instance.linux_server.private_ip


}



output "iam_user" {


  value = aws_iam_user.devops_user.name


}
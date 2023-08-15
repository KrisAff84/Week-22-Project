################################
# Web Server(s)
################################

output "instance_ids" {
  description = "The ID of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id}"
  ]
}
output "ami" {
  description = "The AMI used to launch the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.ami])
}
output "instance_arns" {
  description = "The ARN of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.arn}"
  ]
}
output "instance_azs" {
  description = "The availability zones of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.availability_zone}"
  ]
}
output "instance_state" {
  description = "The state of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.instance_state}"
  ]
}
output "instance_type" {
  description = "The type of the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.instance_type])
}
output "key_name" {
  description = "The key name of the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.key_name])
}
output "private_ips" {
  description = "The private IP address of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.private_ip}"
  ]
}
output "public_ips" {
  description = "The public IP address of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.public_ip}"
  ]
}
output "instance_public_dns" {
  description = "The public DNS name of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.public_dns}"
  ]
}

output "security_groups" {
  description = "The security groups associated with the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.vpc_security_group_ids])
}
output "subnet_ids" {
  description = "The subnet ID of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.subnet_id}"
  ]
}

################################
# Load Balancer
################################

output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = local.load_balancer > 0 ? aws_lb.web[0].arn : null
}
output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = local.load_balancer > 0 ? aws_lb.web[0].dns_name : null
}

###### LB Listener ######

output "listener_arn" {
    description = "The ARN of the load balancer listener"
    value       = local.load_balancer > 0 ? aws_lb_listener.web[0].arn : null
}

##### LB Target Group #####

output "target_group_arn" {
    description = "The ARN of the load balancer target group"
    value       = local.load_balancer > 0 ? aws_lb_target_group.web.arn : null
}

################################
# Security Groups
################################

######## Web Access ########
output "web_access_sg_id" {
  description = "The ID of the web access security group"
  value       = aws_security_group.web_access.id
}

######## SSH Access ########

output "ssh_access_sg_id" {
  description = "The ID of the SSH access security group"
  value       = aws_security_group.ssh_access.id
}

#### Load Balancer Access ####

output "lb_access_sg_id" {
  description = "The ID of the load balancer access security group"
  value       = local.load_balancer > 0 ? aws_security_group.lb_access.id : null
}
#####################################
# Terraform Version and Providers
#####################################

terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      version = "~> 5.10.0"
    }
  }
}
provider "aws" {
  region = var.region
}

#####################################
# Data Sources
#####################################

data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#####################################
# Locals
#####################################

locals {
  public_subnet_ids = var.public_subnet_ids[0] != "" ? var.public_subnet_ids : [data.aws_subnets.public.ids[0]]
  vpc_id            = var.vpc_id != "" ? var.vpc_id : (data.aws_vpc.default.id)
  load_balancer     = length(var.public_subnet_ids) > 1 ? 1 : 0
  default_user_data = <<-EOF
#!/bin/bash
apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>This EC2 instance was deployed with a Terraform module!</h1>" >> /var/www/html/index.html
EOF
}


#####################################
# Web Server(s)
#####################################


resource "aws_instance" "web" {
  count         = length(var.public_subnet_ids) > 1 ? length(var.public_subnet_ids) : 1
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh_access.id,
    local.load_balancer > 0 ? aws_security_group.lb_access[0].id : aws_security_group.web_access.id
  ]
  user_data = var.user_data_file != "" ? file(var.user_data_file) : local.default_user_data
  subnet_id = local.public_subnet_ids[count.index]
  tags = {
    Name = "${var.name_prefix}_web_server_${count.index + 1}"
  }
  associate_public_ip_address = true
}

#####################################
# Security Groups
#####################################

############ Web Access ############
resource "aws_security_group" "web_access" {
  name        = "${var.name_prefix}_web_access_sg"
  description = var.web_access_sg_description
  vpc_id      = local.vpc_id
  ingress {
    from_port   = var.from_port_1
    to_port     = var.to_port_1
    protocol    = var.protocol_1
    cidr_blocks = [var.cidr_block_1]
  }
  ingress {
    from_port   = var.from_port_2
    to_port     = var.to_port_2
    protocol    = var.protocol_2
    cidr_blocks = [var.cidr_block_2]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############ SSH Access ############
resource "aws_security_group" "ssh_access" {
  name        = "${var.name_prefix}_ssh_access_sg"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.from_ssh_port
    to_port     = var.to_ssh_port
    protocol    = var.ssh_protocol
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##### Load Balancer Access #####

resource "aws_security_group" "lb_access" {
  count       = local.load_balancer
  name        = "${var.name_prefix}_lb_access_sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = local.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_access.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#####################################
# Load Balancer
#####################################

resource "aws_lb" "web" {
  count              = local.load_balancer
  name               = "${var.name_prefix}-web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_access.id]
  subnets            = local.public_subnet_ids
  access_logs {
    bucket  = var.lb_access_logs_bucket
    enabled = var.lb_access_logs_enabled
  }
  tags = {
    Name = "${var.name_prefix}-web-lb"
  }
}

############### Listener #####################

resource "aws_lb_listener" "web" {
  count             = local.load_balancer
  load_balancer_arn = aws_lb.web[0].arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web[0].arn
  }
}

############### Target Group #####################

resource "aws_lb_target_group" "web" {
  count    = local.load_balancer
  name     = "${var.name_prefix}-asg-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
}

resource "aws_lb_target_group_attachment" "lb_tg_attachment" {
  count            = local.load_balancer > 0 ? length(aws_instance.web) : 0
  target_group_arn = aws_lb_target_group.web[0].arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
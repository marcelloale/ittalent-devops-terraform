# EC2
resource "aws_instance" "ec2_instance" {
  count         = 2
  ami           = "ami-0b6c2d49148000cd5" 
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  vpc_security_group_ids  = [aws_security_group.nginx_sg_tf.id]     

  tags = {
    Name = "nginx-${count.index + 1}"
  }

  user_data     = file("userdata.tpl")
}

data "aws_vpc" "default" {
 default = true
}

resource "aws_security_group" "nginx_sg_tf" {
  name        = "nginx-sg-tf"
  description = "Allow ssh on 22 & http on port 80"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
provider "aws" {
  region = "sa-east-1" #var.region
}

output "public_dns" {
  value = aws_instance.ec2_instance[*].public_dns
}


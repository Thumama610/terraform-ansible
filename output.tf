output "instance_public_ip" {
  value       = resource.aws_instance.terraform_ec2_instance.public_ip
  description = "The private IP address of the main server instance."
}

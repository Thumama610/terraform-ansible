variable "vpc_id" {
  type        = string
  description = "The default vpc" 
  default     = "vpc-02c88a437b38e7486" # make sure to use the region correctly 
}

variable "subnet_id" {
  type        = string
  description = "The default subnet az-a" 
  default     = "subnet-00c39af4a400fe271" # make sure to use the region and the az correctly 
}

variable "ec2_type" {
  type        = string
  description = "t3.xlarge" 
  default     = "t3.xlarge" 
}

variable "ebs_size" {
  type        = number
  description = "size in GiBs" 
  default     = 30 
}

variable "ebs_type" {
  type        = string
  description = "ebs type" 
  default     = "gp3" 
}

variable "region" {
  type        = string
  description = "aws region" 
  default     = "us-east-1" 
}

variable "key_pair_name" {
  type        = string
  description = "key pair name" 
  default     = "private-key" 
}
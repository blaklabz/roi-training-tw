variable "ami_id" {
  description = "AMI ID for the launch template"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group"
  type        = string
}

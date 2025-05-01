output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.autoscaling_group_name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.asg.launch_template_id
}

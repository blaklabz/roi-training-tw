output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.web_lt.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.web_asg.name
}

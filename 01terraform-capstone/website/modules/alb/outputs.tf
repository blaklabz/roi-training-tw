output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.web_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "asg_name" {
  value = aws_autoscaling_group.app.name
}

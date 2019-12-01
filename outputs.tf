#The name of the LB
output "lb_name" {
  value = aws_lb.application_loadbalancer.name
}

#The ARN of the load balancer
output "lb_arn" {
  value = aws_lb.application_loadbalancer.arn
}

#The DNS name of the load balancer
output "lb_dns_name" {
  value = aws_lb.application_loadbalancer.dns_name
}

#The ARN suffix for use with CloudWatch Metrics
output "lb_arn_suffix" {
  value = aws_lb.application_loadbalancer.arn_suffix
}

#The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)
output "lb_zone_id" {
  value = aws_lb.application_loadbalancer.zone_id
}


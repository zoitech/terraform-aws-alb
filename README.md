# AWS Application Load Balancer Module
Terraform module which sets up an application load balancer with either a HTTP listener, a HTTPS listener or both, and one or more target groups as needed. Terraform version required is 0.12.x .

The following resources are created:
* Application load balancer (internal or external)
* Load balancer listener(s) (HTTP, HTTPS or both)
* Target group(s) (HTTP, HTTPS or both)
* Security groups

## Legend
lb = load balancer  
sg = security group  
tg = target group  

## Usage

```hcl
module "alb" {
  source             = "git::https://github.com/zoitech/terraform-aws-alb.git"
  aws_region         = "eu-central-1"
  vpc_id             = "vpc-1234567b"
  prefix             = "p-dept.123-"
  suffix             = "-abc"
  lb_name            = "my-load-balancer"
  create_internal_lb = true
  lb_security_group_ids   = ["sg-1524364d", "172625db"]
  lb_subnet_ids           = ["subnet-fd42536a", "subnet-98781bac"]
  create_lb_http_listener = true
  lb_http_listener_port   = 80
  http_target_group_parameters = [
    {
      target_group = "application-1-http"
      host_headers = ["application-1.com", "application-1-co.uk"]
      port         = 80
    },
    {
      target_group = "application-2-http"
      host_headers = ["application-2.com", "application-2.de"]
      port         = 10002
    },
  ]

  create_lb_https_listener = true
  lb_https_listener_port   = 443
  https_target_group_parameters = [
    {
      target_group = "application-1-https"
      host_headers = ["application-1.com", "application-1-co.uk"]
      port         = 443
    },
    {
      target_group = "application-2-https"
      host_headers = ["application-2.com", "application-2.de"]
      port         = 10002
    },
  ]
  enable_lb_https_offloading = false
  certificate_arn = "arn:aws:acm:eu-central-1:xxxxxxxxxxx:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

Alternatively, to create a HTTP redirect listener (defaults to HTTPS (443) if "lb_http_redirect_to_protocol" and "lb_http_redirect_to_port" are not configured) :

```hcl
module "alb" {
  source                           = "git::https://github.com/zoitech/terraform-aws-alb.git"
  aws_region                       = "eu-central-1"
  vpc_id                           = "vpc-1234567b"
  prefix                           = "p-dept.123-"
  suffix                           = "-abc"
  lb_name                          = "my-load-balancer"
  create_internal_lb               = true
  lb_subnet_ids                    = ["subnet-fd42536a", "subnet-98781bac"]
  create_lb_http_redirect_listener = true
  lb_http_redirect_listener_port   = 8080
  lb_http_redirect_to_protocol     = "HTTP"
  lb_http_redirect_to_port         = 80
```

### Health Checks

Health checks for all target groups can be set.

HTTP:

```hcl
http_health_check_interval = 15 #default = 30
http_health_check_path = "/status/load-balancer" #default = "/"
http_health_check_port = 1500 #default = "traffic-port"
http_health_check_timeout = 10 #default = 5
http_health_check_healthy_threshold = 2 #default = 3
http_health_check_unhealthy_threshold = 2 #default = 3
http_health_check_matcher = "200-299" #default = 200 (Success codes)
```

HTTPS:
```hcl
https_health_check_interval = 15 #default = 30
https_health_check_path = "/status/load-balancer" #default = "/"
https_health_check_port = 1500 #default = "traffic-port"
https_health_check_timeout = 10 #default = 5
https_health_check_healthy_threshold = 2 #default = 3
https_health_check_unhealthy_threshold = 2 #default = 3
https_health_check_matcher = "200-299" #default = 200 (Success codes)
```

### Target Instance

Are valid for both target groups and need only be set once. Multiple targets should be specified in a comma separated string without spaces. A maximum of 8 targets are currently supported in this module:

```hcl
target_id = "i-00123456789123aaa,i-00123456789123bbb,i-00123456789123ccc"
```

#### HTTPS Offloading
If HTTPS offloading is enabled ("enable_lb_https_offloading = true") the variable "https_target_group_parameters" is not required, as the "http_target_group_parameters" variable will be used.

### HTTP optional arguments (if "create_lb_http_listener = true" )

```hcl
http_target_group_deregistration_delay = 30 #default = 300 (seconds)
http_target_group_stickiness_enabled = true #default set to false
http_target_group_stickiness_cookie_duration = 8640 #default 8640 seconds (1 day)
```

### HTTPS optional arguments (if "create_lb_https_listener = true" )

```hcl
https_target_group_deregistration_delay = 30 #default = 300 (seconds)
https_target_group_stickiness_enabled = true #default set to false
https_target_group_stickiness_cookie_duration = 8640 #default 8640 seconds (1 day)
```

#### Security Groups

The following security groups are created (depending on whether a HTTP listener, HTTPS listener or both are in use).

An empty security group is created and attached to the load balancer, which can be used later as the security group source in other security groups to allow traffic into the instance:

* Group-ALB-${var.lb_name}

The HTTP and HTTPs security groups uses the previously mentioned security group as the source, and is attached to the target instances to allow traffic in:

* group_loadbalancer_in_http
* group_loadbalancer_in_https

### Load Balancer Optional Arguments

Idle timeout (default = 60) for the load balancer, defining if http2 is enabled (default = true) and enabling deletion protection (default = false) can also be set as follows:

```hcl
  lb_idle_timeout = 60
  lb_enable_http2 = true
  lb_enable_deletion_protection = false
```

#### Outputs
The following outputs are available:

* lb_name  (The name of the LB)
* lb_arn (The ARN of the load balancer)
* lb_arn_suffix (The ARN suffix for use with CloudWatch Metrics)
* lb_dns_name (The DNS name of the load balancer)
* lb_zone_id (The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record))

## Referencing a Tagged Version

```hcl
module "alb" {
  source = "git::https://github.com/zoitech/terraform-aws-alb.git?ref=v1.0.4"
```

## Authors
Module managed by [Zoi](https://github.com/zoitech).

## License
MIT License. See LICENSE for full details.

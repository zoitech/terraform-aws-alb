# AWS Application Load Balancer Module
Terraform module which sets up an application load balancer with either a HTTP listener, a HTTPS listener or both, and one or more target groups as required.
The idea behind this module is to support webservers hosting multiple sites for example a windows server running IIS.

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
### Specify this Module as Source
```hcl
module "alb" {
  source = "git::https://github.com/zoitech/terraform-aws-alb.git"

  # Or to specifiy a particular module version:
  source = "git::https://github.com/zoitech/terraform-aws-alb.git?ref=v0.0.1"
```
### Specify the Region to deploy to
```hcl
aws_region = "eu-west-1" #default = "eu-central-1"
```
### Target Group Arguments
The position of the values in each list corresponds to the value in the same position of the other list. E.g. a https request to "serv9.mysite.com" will be sent to the target group with name "Serv9-int-ssl" on port "10503".

Each of the three HTTP lists must contain an equal number of values, as is the case for when using HTTPS.
```hcl
# HTTP required arguments (if "lb_http_listener = true" ):

http_target_group_names = ["Serv1-int", "Serv2-int", "Serv3-int"]
http_target_group_ports = ["10500", "10501", "80"]
http_host_headers = ["serv1.mysite.com", "serv2.mysite.com", "serv3.mysite.com"]
http_health_check_interval = 15 #default = 30
http_health_check_path = "/status/load-balancer" #default = "/"
http_health_check_port = 1500 #default = "traffic-port"
http_health_check_timeout = 10 #default = 5
http_health_check_healthy_threshold = 2 #default = 3
http_health_check_unhealthy_threshold = 2 #default = 3
http_health_check_matcher = "200-299" #default = 200 (Success codes)

# HTTP optional arguments (if "lb_http_listener = true" ):

http_target_group_deregistration_delay = 30 #default = 300 (seconds)
http_target_group_stickiness_enabled = true #default set to false
http_target_group_stickiness_cookie_duration = 8640 #default 8640 seconds (1 day)

# HTTPS required arguments (if "lb_https_listener = true" ):

https_target_group_names = ["Serv1-int-ssl", "Serv2-int-ssl", "Serv9-int-ssl"]
https_target_group_ports = ["443", "8080", "10503"]
https_host_headers = ["serv1.mysite.com", "serv2.mysite.com", "serv9.mysite.com"]
https_health_check_interval = 15 #default = 30
https_health_check_path = "/status/load-balancer" #default = "/"
https_health_check_port = 1500 #default = "traffic-port"
https_health_check_timeout = 10 #default = 5
https_health_check_healthy_threshold = 2 #default = 3
https_health_check_unhealthy_threshold = 2 #default = 3
https_health_check_matcher = "200-299" #default = 200 (Success codes)


# HTTPS optional arguments (if "lb_https_listener = true" ):

https_target_group_deregistration_delay = 30 #default = 300 (seconds)
https_target_group_stickiness_enabled = true #default set to false
https_target_group_stickiness_cookie_duration = 8640 #default 8640 seconds (1 day)

# VPC ID and the target instance are valid for both target groups and need only be set once:

vpc_id = "vpc-a01234bc"
target_id = "i-00123456789123abc"

```


### Load Balancer Required Arguments
#### Internal or External
To configure the load balancer for internal or external (public) use:

```hcl
  lb_internal = false #default = true
```
#### Load Balancer Listener Protocols
The following determines what kind of listener(s) will be applied to the load balancer:
* HTTP
* HTTPS
* or both

```hcl
  lb_http_listener = true #default = true
  *lb_https_listener = true #default = false
```
#### * HTTPS Offloading
To enable offloading from HTTPS to HTTP set the following parameter "lb_https_offloading" to "true":


```hcl
  lb_https_listener   = true #default = false
  lb_https_offloading = true #default = false
```
The following parameters need to be set:
* http_target_group_names
* http_target_group_ports
* https_host_headers

The following parameters need **not** be set as the HTTP counterparts are used instead:
* https_target_group_names
* https_target_group_ports



#### Load Balancer Listener Ports
HTTP/HTTPS listener port of the load balancer depending on what kind of listener(s) are selected:
```hcl
  lb_http_listener_port = 8080 #default = 80
  lb_https_listener_port = 443 #default = 443
```

#### SSL Certificate
If a HTTPS listener is being used, set the SSL certificate:
```hcl
  certificate_arn = "arn:aws:acm:eu-central-1:xxxxxxxxxxxx:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

#### Load Balancer Name

Set the load balancer name:
```hcl
  lb_name = "Internal Services"
```


#### Subnets

Specifying the subnets for the load balancer:

```hcl
  # If the load balancer is internal, configure lb_private_subnet_ids:

  lb_private_subnet_ids = ["subnet-12345678", "subnet-abc87654"]

  # If the load balancer is external, configure lb_public_subnet_ids:

  lb_public_subnet_ids = ["subnet-98765432", "subnet-98765cba"]
```
#### Security Groups
Four security groups are created by default.

An empty security group is created and attached to the load balancer, which can be used later as the security group source in other security groups to allow traffic into the instance:

* "Group-ALB-${var.lb_name}"

The following security group permits all traffic outbound from the load balancer by default:

* "Rule-all-out-all"

A HTTP listener traffic in security group is created to allow HTTP traffic in only from specific sources. The name of the security group is configured as follows:

* "Rule-allow-${var.lb_source_traffic_name}-in-HTTP"

The parameter "lb_source_traffic_name" should be set to a location or department where the source traffic is coming from:

```hcl
  lb_source_traffic_name = "Human-Resources"
```

Alternatively the parameter "lb_sg_http_name" can be set to fully customize the name of the security group. If this parameter is set, "lb_source_traffic_name" is no longer required:

```hcl
  lb_sg_http_name = "My-http-security-group-name"
```
The same applies for the HTTPS security group name:

```hcl
  lb_sg_https_name = "My-https-security-group-name"
```

By default **all IP addresses are permitted** for both the HTTP and HTTPS security group. To specify specific IP ranges (or CIDR blocks) set the following parameters:

```hcl
    rule_allow_lb_http_listener_traffic_in_cidr_blocks = ["172.16.0.0/16", "192.168.0.0/24"]
    rule_allow_lb_https_listener_traffic_in_cidr_blocks = ["172.16.0.0/16", "192.168.0.0/24"]
```

### Load Balancer Optional Arguments
#### Additional Security Groups

Additional security groups can be added to the load balancer:

```hcl
  lb_security_groups = ["sg-12345678", "sg-abc87654"]
```
#### Idle Timeout, HTTP2 and Deletion Protection
Idle timeout (default = 60) for the load balancer, defining if http2 is enabled (default = true) and enabling deletion protection (default = false) can also be set as follows:
```hcl
  lb_idle_timeout = 60
  lb_enable_http2 = true
  lb_enable_deletion_protection = false
```
#### Access Logs
To enable access logs for the load balancer, set the parameter "enable_alb_access_logs = true".  
When set to true, the following parameters should also be configured as shown below:
```hcl
  enable_alb_access_logs = true #default = false
  s3_log_bucket_name = "my-s3-log-bucket"
  s3_log_bucket_Key_name = "alb-logs"
  principle_account_id = "033677994240" #default = 054676820928 (frankfurt) See below for more information
```
To enable a lifecycle rule which will delete the log files after X days, use the following parameters:
```hcl
  lifecycle_rule_enabled = true #default = false
  lifecycle_rule_id = "my_alb_log_expiration"
  lifecycle_rule_expiration = 30 #default = 90
```
The account ID for the principle within the bucket policy needs to match the region to allow the load balancer to write the logs to the bucket.

| Region          | Region Name               | Elastic Load Balancing Account ID  |
| --------------- |:-------------------------:| ----------------------------------:|
| us-east-1       | US East (N. Virginia)     | 127311923021                       |
| us-east-2       | US East (Ohio)            | 033677994240                       |
| us-west-1       | US West (N. California)   | 027434742980                       |
| us-west-2       | US West (Oregon)          | 797873946194                       |
| ca-central-1    | Canada (Central)          | 985666609251                       |
| eu-central-1    | EU (Frankfurt)            | 054676820928                       |
| eu-west-1       | EU (Ireland)              | 156460612806                       |
| eu-west-2       | EU (London)               | 652711504416                       |
| eu-west-3       | EU (Paris)                | 009996457667                       |
| ap-northeast-1  | Asia Pacific (Tokyo)      | 582318560864                       |
| ap-northeast-2  | Asia Pacific (Seoul))     | 600734575887                       |
| ap-northeast-3  | Asia Pacific (Osaka-Local)| 383597477331                       |
| ap-southeast-1  |	Asia Pacific (Singapore)  |	114774131450                       |
| ap-southeast-2  |	Asia Pacific (Sydney)	    | 783225319266                       |
| ap-south-1      |	Asia Pacific (Mumbai)	    | 718504428378                       |
| sa-east-1	      | South America (São Paulo) | 507241528517                       |
| us-gov-west-1\* |	AWS GovCloud (US)         |	048591011584                       |
| cn-north-1 \*\* |	China (Beijing)           |	638102146993                       |
| cn-northwest-1 \*\*|	China (Ningxia)       |	037604701340                       |

\* This region requires a separate account. For more information, see AWS GovCloud (US).

\*\* This region requires a separate account. For more information, see China (Beijing).

For updated account IDs with corresponding regions, please refer to: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy


##### Prefixes and Suffixes (not Latin words ;-))
Can be set when there is a standard naming convention in use. They are applied to the name of the load balancer and target group resources (default = null/empty)
```hcl
  prefix = "P-"
  suffix = "-HR"
```
#### Outputs
The following outputs are possible:
* lb_name  (The name of the LB)
* lb_arn (The ARN of the load balancer)
* lb_arn_suffix (The ARN suffix for use with CloudWatch Metrics)
* lb_dns_name (The DNS name of the load balancer)
* lb_zone_id (The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record))

Example usage:
```hcl
#The name of the LB
output "lb_name" {
  value = "${module.alb.lb_name}"
}
#The ARN of the load balancer
output "lb_arn" {
  value = "${module.alb.lb_arn}"
}
#The ARN suffix for use with CloudWatch Metrics
output "lb_arn_suffix" {
  value = "${module.alb.lb_arn_suffix}"
}
#The DNS name of the load balancer
output "lb_dns_name" {
  value = "${module.alb.lb_dns_name}"
}
#The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)
output "lb_zone_id" {
  value = "${module.alb.lb_zone_id}"
}
```




## Authors
Module managed by [Zoi](https://github.com/zoitech).

## License
MIT License. See LICENSE for full details.

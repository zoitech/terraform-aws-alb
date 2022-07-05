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
  source = "git::https://github.com/zoitech/terraform-aws-alb.git?ref=v2.0.0"
```

## Authors
Module managed by [Zoi](https://github.com/zoitech).

## License
MIT License. See LICENSE for full details.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.application_loadbalancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.application_loadbalancer_listener_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.application_loadbalancer_listener_http_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.application_loadbalancer_listener_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.http_host_based_routing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.https_host_based_routing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.tg_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.tg_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target5](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target7](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_http_tg_target8](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target5](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target7](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.attach_https_tg_target8](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_network_interface_sg_attachment.sg_http_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_sg_attachment) | resource |
| [aws_network_interface_sg_attachment.sg_https_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_sg_attachment) | resource |
| [aws_security_group.group_loadbalancer_in_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.group_loadbalancer_in_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lb_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.rule_loadbalancer_in_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rule_loadbalancer_in_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_instance.target_group_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to run in. | `string` | `"eu-central-1"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate ARN for the HTTPS listener | `any` | `null` | no |
| <a name="input_create_internal_lb"></a> [create\_internal\_lb](#input\_create\_internal\_lb) | Define if the loadbalancer should be internal or not | `bool` | `true` | no |
| <a name="input_create_lb_http_listener"></a> [create\_lb\_http\_listener](#input\_create\_lb\_http\_listener) | If true add a HTTP listener | `bool` | `false` | no |
| <a name="input_create_lb_http_redirect_listener"></a> [create\_lb\_http\_redirect\_listener](#input\_create\_lb\_http\_redirect\_listener) | # load balancer http redirect listener | `bool` | `false` | no |
| <a name="input_create_lb_https_listener"></a> [create\_lb\_https\_listener](#input\_create\_lb\_https\_listener) | If true add a HTTPS listener | `bool` | `false` | no |
| <a name="input_enable_lb_https_offloading"></a> [enable\_lb\_https\_offloading](#input\_enable\_lb\_https\_offloading) | If true offload to HTTP | `bool` | `true` | no |
| <a name="input_http_health_check_healthy_threshold"></a> [http\_health\_check\_healthy\_threshold](#input\_http\_health\_check\_healthy\_threshold) | Set HTTP health check healthy threshold | `number` | `3` | no |
| <a name="input_http_health_check_interval"></a> [http\_health\_check\_interval](#input\_http\_health\_check\_interval) | Set HTTP health check interval | `number` | `30` | no |
| <a name="input_http_health_check_matcher"></a> [http\_health\_check\_matcher](#input\_http\_health\_check\_matcher) | Set HTTP health check matcher | `number` | `200` | no |
| <a name="input_http_health_check_path"></a> [http\_health\_check\_path](#input\_http\_health\_check\_path) | Set HTTP health check path | `string` | `"/"` | no |
| <a name="input_http_health_check_port"></a> [http\_health\_check\_port](#input\_http\_health\_check\_port) | Set HTTP health check port | `string` | `"traffic-port"` | no |
| <a name="input_http_health_check_protocol"></a> [http\_health\_check\_protocol](#input\_http\_health\_check\_protocol) | Set HTTP health check protocol | `string` | `"HTTP"` | no |
| <a name="input_http_health_check_timeout"></a> [http\_health\_check\_timeout](#input\_http\_health\_check\_timeout) | Set HTTP health check timeout | `number` | `5` | no |
| <a name="input_http_health_check_unhealthy_threshold"></a> [http\_health\_check\_unhealthy\_threshold](#input\_http\_health\_check\_unhealthy\_threshold) | Set HTTP health check unhealthy threshold | `number` | `3` | no |
| <a name="input_http_target_group_deregistration_delay"></a> [http\_target\_group\_deregistration\_delay](#input\_http\_target\_group\_deregistration\_delay) | Deregistration delay for the http target group(s) | `number` | `300` | no |
| <a name="input_http_target_group_parameters"></a> [http\_target\_group\_parameters](#input\_http\_target\_group\_parameters) | ## HTTP target group variables ### | `list(any)` | `null` | no |
| <a name="input_http_target_group_stickiness_cookie_duration"></a> [http\_target\_group\_stickiness\_cookie\_duration](#input\_http\_target\_group\_stickiness\_cookie\_duration) | Cookie Duration for stickiness of the http target group(s) | `number` | `8640` | no |
| <a name="input_http_target_group_stickiness_enabled"></a> [http\_target\_group\_stickiness\_enabled](#input\_http\_target\_group\_stickiness\_enabled) | Turn stickiness on/off for the http target group(s) | `bool` | `false` | no |
| <a name="input_https_health_check_healthy_threshold"></a> [https\_health\_check\_healthy\_threshold](#input\_https\_health\_check\_healthy\_threshold) | Set HTTPS health check healthy threshold | `number` | `3` | no |
| <a name="input_https_health_check_interval"></a> [https\_health\_check\_interval](#input\_https\_health\_check\_interval) | Set HTTPS health check interval | `number` | `30` | no |
| <a name="input_https_health_check_matcher"></a> [https\_health\_check\_matcher](#input\_https\_health\_check\_matcher) | Set HTTPS health check matcher | `number` | `200` | no |
| <a name="input_https_health_check_path"></a> [https\_health\_check\_path](#input\_https\_health\_check\_path) | Set HTTPS health check path | `string` | `"/"` | no |
| <a name="input_https_health_check_port"></a> [https\_health\_check\_port](#input\_https\_health\_check\_port) | Set HTTPS health check port | `string` | `"traffic-port"` | no |
| <a name="input_https_health_check_protocol"></a> [https\_health\_check\_protocol](#input\_https\_health\_check\_protocol) | Set HTTPS health check protocol | `string` | `"HTTPS"` | no |
| <a name="input_https_health_check_timeout"></a> [https\_health\_check\_timeout](#input\_https\_health\_check\_timeout) | Set HTTPS health check timeout | `number` | `5` | no |
| <a name="input_https_health_check_unhealthy_threshold"></a> [https\_health\_check\_unhealthy\_threshold](#input\_https\_health\_check\_unhealthy\_threshold) | Set HTTPS health check unhealthy threshold | `number` | `3` | no |
| <a name="input_https_target_group_deregistration_delay"></a> [https\_target\_group\_deregistration\_delay](#input\_https\_target\_group\_deregistration\_delay) | Deregistration delay for the https target group(s) | `number` | `300` | no |
| <a name="input_https_target_group_parameters"></a> [https\_target\_group\_parameters](#input\_https\_target\_group\_parameters) | ## HTTPS target group variables ### | `list(any)` | `null` | no |
| <a name="input_https_target_group_stickiness_cookie_duration"></a> [https\_target\_group\_stickiness\_cookie\_duration](#input\_https\_target\_group\_stickiness\_cookie\_duration) | Cookie Duration for stickiness of the https target group(s) | `number` | `8640` | no |
| <a name="input_https_target_group_stickiness_enabled"></a> [https\_target\_group\_stickiness\_enabled](#input\_https\_target\_group\_stickiness\_enabled) | Turn stickiness on/off for the https target group(s) | `bool` | `false` | no |
| <a name="input_lb_enable_deletion_protection"></a> [lb\_enable\_deletion\_protection](#input\_lb\_enable\_deletion\_protection) | Enable deletion protection | `bool` | `false` | no |
| <a name="input_lb_enable_http2"></a> [lb\_enable\_http2](#input\_lb\_enable\_http2) | Define is http2 is enabled | `bool` | `true` | no |
| <a name="input_lb_http_listener_port"></a> [lb\_http\_listener\_port](#input\_lb\_http\_listener\_port) | HTTP listener port of the loadbalancer | `number` | `80` | no |
| <a name="input_lb_http_redirect_listener_port"></a> [lb\_http\_redirect\_listener\_port](#input\_lb\_http\_redirect\_listener\_port) | HTTP redirect listener port of the loadbalancer | `number` | `80` | no |
| <a name="input_lb_http_redirect_to_port"></a> [lb\_http\_redirect\_to\_port](#input\_lb\_http\_redirect\_to\_port) | HTTP redirect listener to loadbalancer port | `number` | `443` | no |
| <a name="input_lb_http_redirect_to_protocol"></a> [lb\_http\_redirect\_to\_protocol](#input\_lb\_http\_redirect\_to\_protocol) | HTTP redirect listener to loadbalancer protocol | `string` | `"HTTPS"` | no |
| <a name="input_lb_https_listener_port"></a> [lb\_https\_listener\_port](#input\_lb\_https\_listener\_port) | HTTPS listener port of the loadbalancer | `number` | `443` | no |
| <a name="input_lb_idle_timeout"></a> [lb\_idle\_timeout](#input\_lb\_idle\_timeout) | Idle timeout for the loadbalancer. | `number` | `60` | no |
| <a name="input_lb_logs_bucket_enabled"></a> [lb\_logs\_bucket\_enabled](#input\_lb\_logs\_bucket\_enabled) | Boolean to enable / disable access\_logs | `bool` | `true` | no |
| <a name="input_lb_logs_bucket_name"></a> [lb\_logs\_bucket\_name](#input\_lb\_logs\_bucket\_name) | The S3 bucket name to store the logs in | `string` | `""` | no |
| <a name="input_lb_logs_bucket_prefix"></a> [lb\_logs\_bucket\_prefix](#input\_lb\_logs\_bucket\_prefix) | The S3 bucket prefix. Logs are stored in the root if not configured | `string` | `""` | no |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | Name of the loadbalancer | `string` | `"loadbalancer"` | no |
| <a name="input_lb_security_group_ids"></a> [lb\_security\_group\_ids](#input\_lb\_security\_group\_ids) | Additional Security Group ID(s) which should be attached to the loadbalancer | `list(string)` | `[]` | no |
| <a name="input_lb_subnet_ids"></a> [lb\_subnet\_ids](#input\_lb\_subnet\_ids) | The subnet ID(s) which should be attached to the loadbalancer | `list(string)` | `[]` | no |
| <a name="input_lb_tags"></a> [lb\_tags](#input\_lb\_tags) | Tags for the load balancer | `map(string)` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix which is added to each resource name. | `string` | `""` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | A suffix which is added to each resource name. | `string` | `""` | no |
| <a name="input_target_ids"></a> [target\_ids](#input\_target\_ids) | Instance IDs for the target group(s) | `string` | `""` | no |
| <a name="input_tg_tags"></a> [tg\_tags](#input\_tg\_tags) | Tags for target groups | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID in which the resources should be created. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | The ARN of the load balancer |
| <a name="output_lb_arn_suffix"></a> [lb\_arn\_suffix](#output\_lb\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name of the load balancer |
| <a name="output_lb_name"></a> [lb\_name](#output\_lb\_name) | The name of the LB |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record) |

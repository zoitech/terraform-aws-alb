## 1.0.0

BACKWARDS INCOMPATIBILITIES / NOTES:

* Terraform version 0.12.x
* List variables "http_target_group_names", "http_target_group_ports" and "http_host_headers" replaced with list of objects variable "http_target_group_parameters" ([#11](https://github.com/zoitech/terraform-aws-saml/issues/11))
* List variables "https_target_group_names", "https_target_group_ports" and "https_host_headers" replaced with list of objects variable "https_target_group_parameters" ([#11](httpss://github.com/zoitech/terraform-aws-saml/issues/11))
* Changed variable name of "lb_http_listener" to "create_lb_http_listener" ([#12](https://github.com/zoitech/terraform-aws-saml/issues/12))
Changed variable name of "lb_https_listener" to "create_lb_https_listener" ([#12](httpss://github.com/zoitech/terraform-aws-saml/issues/12))
* Changed variable name of "lb_internal" to "create_internal_lb" ([#12](httpss://github.com/zoitech/terraform-aws-saml/issues/12))
* Changed variabble name of "lb_https_offloading" to "enable_lb_https_offloading" ([#12](httpss://github.com/zoitech/terraform-aws-saml/issues/12))
* Variables "lb_private_subnet_ids" and "lb_public_subnet_ids" replaced with "lb_subnet_ids"

ENHANCEMENTS:

* Upgraded module to terraform 0.12.x ([#10](https://github.com/zoitech/terraform-aws-saml/issues/10))
* Reduced security group complexity ([#13](https://github.com/zoitech/terraform-aws-saml/issues/13))
* Specify the port ranges of the allowed load balancer traffic into the instance(s) with variables "lb_in_from_port" and "lb_in_to_port" ([#13](https://github.com/zoitech/terraform-aws-saml/issues/13))

## 0.0.2

BACKWARDS INCOMPATIBILITIES / NOTES:

* N/A

NEW FEATURES:

* The HTTPS listener now supports offloading to HTTP target groups.
(Activated by setting parameter "lb_https_offloading=true")
* Ability to add multiple targets to target groups

IMPROVEMENTS:

* Added the following output values:  
 * lb_name
 * lb_arn
 * lb_arn_suffix
 * lb_dns_name
 * lb_zone_id

BUG FIXES:

* Corrected "lb_security_group_ids" typo in README.md

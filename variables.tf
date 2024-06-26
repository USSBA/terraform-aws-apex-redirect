# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  REQUIRED
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
variable "service_name" {
  type        = string
  description = "A unique name for Fargate service."
}
variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet ids that will be associated with the network load balancer."
}
variable "redirect_fqdn" {
  type        = string
  description = "The FQDN where redirected traffic will be directed."
}
variable "log_group_name" {
  type        = string
  description = "A name for the CloudWatch Log Group that will created."
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  OPTIONAL
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Task
variable "task_cpu" {
  type        = number
  description = "A fargate compliant CPU allocation. (default: 256)"
  default     = 256
}
variable "task_memory" {
  type        = number
  description = "A Fargate compliance Memory allocation. (default: 512)"
  default     = 512
}
variable "hsts_header_value" {
  type        = string
  description = "A valid HSTS header value (eg. max-age=31536000; preload)"
  default     = "max-age=31536000"
}
variable "command" {
  type        = list(string)
  description = "Optional: An override for the containers start command."
  default = [
    "/bin/sh",
    "-c",
    <<-COMMAND
      #echo "127.0.0.1 $APEX_DOMAIN" >> /etc/hosts;
      #echo "::1 $APEX_DOMAIN" >> /etc/hosts;
      bind 127.0.0.1 [::1]
      apk add curl;
      echo -e "$APEX_DOMAIN
      header Strict-Transport-Security \"$HSTS_HEADER_VALUE\"
      redir https://$REDIRECT_DOMAIN{uri} 301
      log {
        output stdout
      }" > /etc/caddy/Caddyfile && \
      caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
    COMMAND
  ]
}

# Service
variable "apex_fqdn" {
  type        = string
  description = "The FQDN the server will be running on.  Required for certificate generation by Caddy, but defaults to the redirect fqdn with the subdomain stripped off."
  default     = ""
}
variable "is_certificate_valid" {
  type        = bool
  description = "If testing with an invalid certificate [eg. Self-Signed Cert], change this to false to ensure the NLB Health Check doesn't kill your service"
  default     = true
}
variable "desired_count" {
  type        = number
  description = "The number of Fargate task(s) to run. (default: equal to the number of subnet_ids provided)"
  default     = 0
}
variable "enable_execute_command" {
  type        = bool
  description = "Optional; Enable executing into running tasks using ECS Exec.  NOTE: Enabling this grants tasks ssmmessages and logs write permissions"
  default     = false
}

# Logging
variable "log_retention_in_days" {
  type        = number
  description = "Log Groups by default retain all logs forever."
  default     = 90
}
variable "access_log_bucket" {
  type        = string
  nullable    = true
  description = "Optional: An s3 bucket where the NLB access logs will be dropped."
  default     = ""
}
variable "access_log_prefix" {
  type        = string
  nullable    = true
  description = "Optional: An s3 object key prefix for logs written to the configured bucket. Defaults to `null` and only appled when an access_log_bucket is provided."
  default     = ""
}

# Networking
variable "cluster_name" {
  type        = string
  description = "Optional; An ECS cluster name."
  default     = "default"
}
variable "eip_allocation_ids" {
  type        = list(string)
  description = "Optional; A list of EIP allocation ids that will be mapped to your subnets. (Leave empty to have module create them.)"
  default     = []
}
variable "ipv6_subnet_mappings" {
  type = list(object({
    id      = string,
    address = string
  }))
  description = "Optional: A list of SubnetIds to IPv6 addresses. Example: [ for s in data.aws_subnet.public : { id = s.id, address = \"$${replace(s.ipv6_cidr_block,\":/64\", \"\")}a1b2:a1b2:a1b2:a1b2\" }]"
  default     = []
}

# Tags
variable "tags" {
  type        = map(any)
  description = "Optional; Map of key-value tags to apply to all resources"
  default     = {}
}
variable "tags_efs" {
  type        = map(any)
  description = "Optional; Map of key-value tags to apply to efs resources"
  default     = {}
}

# Other
variable "wait_for_steady_state" {
  type        = bool
  description = "Optional; Configure terraform to wait for ECS service to be deployed and stable before terraform finishes.  Note that Fargate deployments can take a remarkably long time to reach a steady state, and thus your terraform deployment times will increase by a few minutes.  Defaults to false"
  default     = false
}
variable "apex_restart_enabled" {
  type        = bool
  description = "Optional; Enables a cloudwatch event and lambda to perform a monthly container restart"
  default     = false
}
variable "healthcheck_sns_arn" {
  type        = string
  description = "Optional; An SNS topic you'd like to have notified when the Route53 HealthCheck for this service fails"
  default     = null
}

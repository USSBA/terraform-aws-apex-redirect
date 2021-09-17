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
variable "hsts_header_value" {
  type        = string
  description = "A valid HSTS header value (eg. max-age=31536000; preload)"
  default     = "max-age=31536000"
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  OPTIONAL
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
variable "cluster_name" {
  type        = string
  description = "An ECS cluster name."
  default     = "default"
}
variable "eip_allocation_ids" {
  type        = list(string)
  description = "A list of EIP allocation ids that will be maped to your subnets. (Leave empty to have module create them.)"
  default     = []
}
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
variable "is_certificate_valid" {
  type        = bool
  description = "If testing with an invalid certificate [eg. Self-Signed Cert], change this to false to ensure the NLB Health Check doesn't kill your service"
  default     = true
}

variable "log_retention_in_days" {
  type        = number
  description = "Log Groups by default retain all logs forever."
  default     = 90
}
variable "apex_fqdn" {
  type        = string
  description = "The FQDN the server will be running on.  Required for certificate generation by Caddy, but defaults to the redirect fqdn with the subdomain stripped off."
  default     = ""
}
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
variable "enable_execute_command" {
  type        = bool
  description = "Optional; Enable executing into running tasks using ECS Exec.  NOTE: Enabling this grants tasks ssmmessages and logs write permissions"
  default     = false
}
variable "wait_for_steady_state" {
  type        = bool
  description = "Optional; Configure terraform to wait for ECS service to be deployed and stable before terraform finishes.  Note that Fargate deployments can take a remarkably long time to reach a steady state, and thus your terraform deployment times will increase by a few minutes.  Defaults to false"
  default     = false
}

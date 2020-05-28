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
variable "cluster_name" {
  type        = string
  description = "An ECS cluster name."
}
variable "redirect_fqdn" {
  type        = string
  description = "The FQDN where redirected traffic will be directed."
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  OPTIONAL
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
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



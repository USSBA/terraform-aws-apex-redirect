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
  default     = "default"
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
variable "aws_s3_bucket_name" {
  type        = string
  description = "The bucket name containing SSL certificates"
}
variable "aws_s3_key_fullchain_pem" {
  type        = string
  description = "The s3 path to fullchain pem file"
}
variable "aws_s3_key_privatekey_pem" {
  type        = string
  description = "The s3 path to private key pem file"
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
variable "is_certificate_valid" {
  type        = bool
  description = "If testing with an invalid certificate [eg. Self-Signed Cert], change this to false to ensure the NLB Health Check doesn't kill your service"
  default     = true
}

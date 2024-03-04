variable "subnet_ids" {
  type = list(string)
}
variable "cluster_name" {
  type = string
}
variable "subnet_ipv6_mapping" {
  type = list(object({
    id      = string,
    address = string,
  }))
}
module "apex" {
  source = "../../"

  service_name         = "example"
  log_group_name       = "/fargate/example"
  subnet_ids           = var.subnet_ids
  cluster_name         = var.cluster_name
  redirect_fqdn        = "example.com"
  apex_fqdn            = "www.example.com"
  apex_restart_enabled = true
  ipv6_subnet_mappings = var.subnet_ipv6_mapping
}

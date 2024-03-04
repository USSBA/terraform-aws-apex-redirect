variable "subnet_ids" {
  type = list(string)
}
variable "cluster_name" {
  type = string
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
}

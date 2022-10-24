module "simple" {
  source  = "USSBA/apex-redirect/aws"
  version = "~> 5.0"

  service_name           = "apex-redirect"
  subnet_ids             = ["subnet-00000000000000001", "subnet-00000000000000002"]
  desired_count          = 1
  redirect_fqdn          = "www.example.com"
  hsts_header_value      = "max-age=31536000"
  log_group_name         = "/simple/example/apex-redirect"
  log_retention_in_days  = 90
  enable_execute_command = true
  apex_restart_enabled   = true
  wait_for_steady_state  = true
}

output "apex-redirect-module" {
  value = module.simple.ip.*.public_ip
}

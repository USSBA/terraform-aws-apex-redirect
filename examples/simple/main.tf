data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
module "simple" {
  source = "../../"
  #source  = "USSBA/apex-redirect/aws"
  #version = "~> 4.0"

  service_name           = "apex-redirect-simple"
  subnet_ids             = slice(tolist(data.aws_subnet_ids.default.ids), 0, 2)
  redirect_fqdn          = "www.management.ussba.io"
  hsts_header_value      = "max-age=31536000"
  log_retention_in_days  = 90
  enable_execute_command = true
  wait_for_steady_state  = true
  monthly_restart_enabled = true
  tags = {
    Name      = "apex-redirect-simple"
    CreatedBy = "terraform"
  }
}

module "apex-restart" {
  count = var.monthly_restart_enabled ? 1 : 0
  source = "./apex-restart/"

  service_name = "apex-redirect-simple"
}

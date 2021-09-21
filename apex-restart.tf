module "apex-restart" {
  count  = var.apex_restart_enabled ? 1 : 0
  source = "./apex-restart/"

  service_name = var.service_name
  cluster_name = var.cluster_name
}

variable "name_prefix" {
  type = string
  description = "A value used for naming and tagging purposes"
  default = "apex"
}
variable "vpc_subnet_ids" {
  type = list(string)
  description = "A list of subnet ids that will be associated with the network load balancer."
  #default = []
  default = ["subnet-7c584c34", "subnet-fcfeb6a6", "subnet-9c569ef8"]
}
variable "vpc_eip_allocation_ids" {
  type = list(string)
  description = "A list of EIP allocation ids that will be maped to your subnets."
  default = []
  #default = ["alloc1","alloc2"]
}
variable "ecs_cluster_name" {
  type = string
  description = "The name of an existing ECS cluser Fargate tasks will run"
  default = "default"
}

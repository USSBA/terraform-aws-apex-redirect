resource "aws_security_group" "efs" {
  description = "${var.service_name} EFS Cert Storage"
  vpc_id      = data.aws_subnet.target[0].vpc_id
}

resource "aws_efs_file_system" "efs" {
  creation_token = var.service_name

  tags = merge(
    var.tags,
    { Name = var.service_name },
    var.tags_efs
  )
}

resource "aws_efs_mount_target" "efs" {
  for_each        = toset(data.aws_subnet.target[*].id)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs.id]
}

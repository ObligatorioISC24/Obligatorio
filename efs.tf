resource "aws_efs_file_system" "obligatorio-efs" {
  creation_token = "token"
}

resource "aws_efs_mount_target" "obligatorio-efs-mount-tgA" {
  count = 1
  file_system_id = aws_efs_file_system.obligatorio-efs.id
  subnet_id = aws_subnet.obligatorio-tf-subnet-a.id
  security_groups = [aws_security_group.obligatorio-sg-EFS.id]
}

resource "aws_efs_mount_target" "obligatorio-efs-mount-tgB" {
  count = 1
  file_system_id = aws_efs_file_system.obligatorio-efs.id
  subnet_id = aws_subnet.obligatorio-tf-subnet-b.id
  security_groups = [aws_security_group.obligatorio-sg-EFS.id]
}

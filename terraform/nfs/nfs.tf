resource "aws_efs_file_system" "efs" {
  creation_token = "efs"

  # Replaces dns name in the bash file to mount nfs to ec2 on launch.
  provisioner "local-exec" {
    command = "sed -i 's/nfs-dns/${self.dns_name}/g' ${var.user_data_file}"
  }

  tags = {
    Name = "efs"
  }
}

# Creating Mount target of EFS
resource "aws_efs_mount_target" "mount" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.nfs.id]
}

resource "aws_security_group" "nfs" {
  name        = "nfs"
  description = "Security group for nfs"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      var.cidr_blocks,
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      var.cidr_blocks,
    ]
  }
  tags = {
    Name = "allow-nfs-ec2"
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "efs"

  # Replaces dns name in the bash file to mount nfs to ec2 on launch.
  provisioner "local-exec" {
    command = "sed -i 's/nfs-dns/${self.dns_name}/g' ../bash/package.sh"
  }

  tags = {
    Name = "efs"
  }
}

# Creating Mount target of EFS
resource "aws_efs_mount_target" "mount" {
  for_each        = concat(module.vpc.private-subnet-output, module.vpc.public-subnet-output)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.nfs.id]
}


resource "aws_security_group" "nfs" {
  name        = "sg-nfs"
  description = "Security group for nfs"
  vpc_id      = module.vpc.vpc_main.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      module.vpc.vpc_main.cidr_block,
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      module.vpc.vpc_main.cidr_block,
    ]
  }
  tag {
    Name = "allow-nfs-ec2"
  }
}
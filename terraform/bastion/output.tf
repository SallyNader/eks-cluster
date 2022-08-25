# Gets first private ip of instances.
output "bastion-private-ip" {
  value = "${ element(data.aws_instance.bastion-instances.private_ip, 0) }"
}
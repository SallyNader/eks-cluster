data "aws_instances" "bastion-instances" {
  depends_on = [ aws_autoscaling_group.web ]
  
  instance_tags {
    key = "bastion-hosts"
  }
}
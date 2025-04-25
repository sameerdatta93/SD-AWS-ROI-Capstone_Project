data "aws_region" "current" {}
data "template_file" "userdata" {
  template = file("${path.module}/userdata.sh")
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "dev-application-launch-template"
  image_id      = lookup(var.ami_id, data.aws_region.current.name, null)
  instance_type = var.instance_type
  # iam_instance_profile {
  #  name = var.instance_profile_name
  #}
  #user_data = base64encode(templatefile("${path.module}/userdata.sh", {
  #   repo_url = var.userdata_repo_url
  #}))
  user_data = base64encode(data.template_file.userdata.rendered)
  vpc_security_group_ids = [var.sg_id]
}


resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 1
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.private_subnets
  target_group_arns    = [var.alb_target_group_arn]
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

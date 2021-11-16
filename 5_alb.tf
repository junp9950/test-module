resource "aws_ami_from_instance" "jwshin_ami" {
  name               = "jwshin-aws-ami"
  source_instance_id = aws_instance.jwshin_weba.id

  depends_on = [
    aws_instance.jwshin_weba
  ]

}

resource "aws_launch_configuration" "jwshin_aslc" {
    name_prefix = "jwshin_web-"
    image_id = aws_ami_from_instance.jwshin_ami.id
    instance_type = "t2.micro"
    iam_instance_profile = "admin_role"
    security_groups = [aws_security_group.jwshin_sg.id]
    key_name = ""
    #user_data = file("./install.sh")

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_placement_group" "jwshin_place" {
    name = "${var.name}-place"
    strategy = "cluster"
}

resource "aws_autoscaling_group" "jwshin_asg" {
  name                      = "${var.name}-asg"
  min_size                  = 2
  max_size                  = 10
  health_check_grace_period = 10
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.jwshin_aslc.name
  vpc_zone_identifier       = [aws_subnet.jwshin_pub[0].id, aws_subnet.jwshin_pub[1].id]
}

resource "aws_autoscaling_attachment" "jwshin_asgalbatt" {
    autoscaling_group_name = aws_autoscaling_group.jwshin_asg.id
    alb_target_group_arn = aws_lb_target_group.jwshin_albtg.arn
    }
resource "aws_launch_template" "web_lt" {
  name_prefix   = "capstone-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo rm -rf /usr/share/nginx/html/*
              cd /usr/share/nginx/html/
              curl -O https://raw.githubusercontent.com/blaklabz/roi-training-tw/main/capstone/website/index.html
              curl -o galaga.png https://raw.githubusercontent.com/blaklabz/roi-training-tw/main/capstone/website/images/galaga.png
              sudo systemctl restart nginx
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "capstone-web"
      project = "capstone"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "capstone-web-asg"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "capstone-web"
    propagate_at_launch = true
  }
}

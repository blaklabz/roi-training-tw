resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo rm -rf /usr/share/nginx/html/*
              cd /usr/share/nginx/html

              # Download index.html
              curl -O https://raw.githubusercontent.com/blaklabz/roi-training-tw/main/index.html

              # Download Galaga image
              curl -o galaga.png https://raw.githubusercontent.com/blaklabz/roi-training-tw/main/capstone/website/images/galaga.png
              sudo systemctl restart nginx
              EOF

  tags = {
    Name    = var.instance_name
    project = "capstone"
  }
}

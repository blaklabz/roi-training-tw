packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "nginx_capstone" {
  region                 = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["137112412989"]  # Amazon official
    most_recent = true
  }
  instance_type                = "t2.micro"
  ssh_username                 = "ec2-user"
  ami_name                     = "nginx-capstone-ami-{{timestamp}}"
  associate_public_ip_address  = true

  tags = {
    Name         = "nginx-capstone-ami"
    salted       = "true"
    https_ready  = "true"
  }
}

build {
  name    = "nginx-capstone-ami"
  sources = ["source.amazon-ebs.nginx_capstone"]

  provisioner "shell" {
    inline = [
      # Update system and install nginx
      "sudo yum update -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum clean metadata",
      "sudo yum install -y nginx",

      # Create SSL directory and self-signed cert
      "sudo mkdir -p /etc/nginx/ssl",
      "sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj '/CN=localhost'",

      # Replace nginx.conf with correct reverse proxy config
      <<-EOT
sudo bash -c 'cat > /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name localhost;

        location / {
            return 301 https://\$host\$request_uri;
        }
    }

    server {
        listen 443 ssl;
        server_name localhost;

        ssl_certificate /etc/nginx/ssl/nginx.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx.key;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }
    }
}
EOF'
EOT
      ,

      # Start nginx
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}

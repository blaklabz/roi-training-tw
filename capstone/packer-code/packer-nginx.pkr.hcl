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
  instance_type          = "t2.micro"
  ssh_username           = "ec2-user"
  ami_name               = "nginx-capstone-ami-{{timestamp}}"
}

build {
  name    = "nginx-capstone-ami"
  sources = ["source.amazon-ebs.nginx_capstone"]

  provisioner "shell" {
    inline = [
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum clean metadata",
      "sudo yum install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}

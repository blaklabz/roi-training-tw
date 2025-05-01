# Description - roi-training-tw
This capstone project has been fun for me and I really enjoy being able to solve a problem multiple different ways. This readme will cover how I created the environment and what is needed to execute the code.

### **capstone-mgt-srv**
This management node was created manually in ***us-east-2*** as ***i-0b33e27c06f8de3b3*** and has both Terraform and Packer installed. This node is connected to the following github **repo:**
*https://github.com/blaklabz/roi-training-tw.git*

### **running packer on capstone-mgt-srv**
inside /roi-training-tw/capstone/packer-code/ resides the packer build file.

the build file is called packer-nginx-https2.pkr.hcl

to run this file: packer build packer-nginx-https2.pkr.hcl

**note:** *this image is prebuilt with nginx set with a reverse proxy*

### **running simple_vm terraform project on capstone-mgt-srv**

inside /roi-training-tw/capstone/simple_vm/ resides the ec2 build files

to run this terraform project: terraform apply -auto-approve

**note:** *this build out attempts to set the salt-minion but i had some trouble getting to the salt repo but i wanted to leave this here to show the attempt to get orchestration prebuilt into the ec2. However, this ec2 should
display a default nginx page when queried.*

### **running website terraform project on capstone-mgt-srv**

inside /roi-training-tw/capstone/website/ resides the modular terraform build out.

to run this terraform project: terraform apply -auto-approve

**note:** *This build out creates an alb, asg, security_group, and the vpc. This project is triggered at the root
level, taking advantage of the modules to enable exactly what I performed in this example.  I initially built this out ommiting the ASG, and useing the ec2 module. But because of the structure of methodology, I was quickly able to build out the ASG and tie in its module to perform this build out. If you get bored one day you can see the commit tree where i make this change to add the ASG and fix its bugs while leaving the rest of the project intact. On top of this, this build out leans on the nginx that was prebuilt in to the AMI.  Instead of a game I decided to be a bit creative and create a static page within nginx for it to display and used user_data to implement this update to the default nginx page that will be displayed.*

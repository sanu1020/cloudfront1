resource "aws_instance" "sanujan-demo-workflows" {
    ami = "ami-08c40ec9ead489470"
    instance_type = "t2.micro"
    key_name = "terraform-key"

    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server building pipeline > /var/www/html/index.html'
                EOF
    
    tags = {
      Name = "sanujan-demo-workflows-dev"
    }
}
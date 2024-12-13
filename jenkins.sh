#!/bin/bash
# Run as root
sudo su 

# Update and install Jenkins dependencies
yum -y update 
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto-devel -y
yum install -y jenkins

# Start and enable Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Nginx for the health check endpoint
yum install -y nginx

# Create the health check HTML file
mkdir -p /var/www/healthcheck
echo "<html><body>Healthy</body></html>" > /var/www/healthcheck/index.html

# Configure Nginx to serve the health check page on port 8081
cat <<EOT > /etc/nginx/conf.d/healthcheck.conf
server {
    listen 8081;
    location / {
        root /var/www/healthcheck;
        index index.html;
    }
}
EOT

# Start and enable Nginx to serve the health check endpoint
sudo systemctl enable nginx
sudo systemctl start nginx

# Print the Jenkins initial admin password to the logs
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

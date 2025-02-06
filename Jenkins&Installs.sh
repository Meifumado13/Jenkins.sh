#!/bin/bash
# Run as root
sudo su 

# Update and install Jenkins dependencies
yum -y update 
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto-devel -y
sudo yum install -y jenkins-2.479.3-1.1.noarch

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

# Install Required Packages
echo "Updating system and installing basic utilities..."
sudo yum install -y git unzip curl wget

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install
rm -rf /tmp/awscliv2.zip /tmp/aws

# Install Terraform
echo "Installing Terraform..."
curl -fsSL https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -o ~/terraform.zip
sudo unzip ~/terraform.zip -d /usr/local/bin
rm ~/terraform.zip

# Install SonarScanner
echo "Installing SonarScanner..."
curl -fsSL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip -o /tmp/sonar-scanner.zip
sudo unzip /tmp/sonar-scanner.zip -d /opt/
sudo mv /opt/sonar-scanner-* /opt/sonar-scanner
sudo ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
rm /tmp/sonar-scanner.zip

# Install Node.js & npm
echo "Installing Node.js & npm..."
sudo yum install -y nodejs npm
node -v
npm -v

# Install Snyk
echo "Installing Snyk..."
sudo npm install -g snyk

# Ensure Git is installed
echo "Ensuring Git is installed..."
sudo yum install -y git

# Print the Jenkins initial admin password to the logs
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "All installations completed successfully."

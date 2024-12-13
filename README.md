# Jenkins Setup Script

This script automates the installation and configuration of Jenkins on an Amazon Linux 2023 EC2 instance. Follow the steps below to complete the setup and access Jenkins.

## Prerequisites
- Ensure the EC2 instance has inbound security group rules for:
  - HTTP (port 80) for web access
  - Custom TCP (port 8080) for Jenkins UI access

## Steps to Access Jenkins

1. **Run the User Data Script**  
   Launch an EC2 instance with the provided user data script. The script will:
   - Install required dependencies
   - Download and start Jenkins

2. **Retrieve the Initial Admin Password**
   After the instance has started:
   - SSH into the EC2 instance:
     ```bash
     ssh -i <your-key.pem> ec2-user@<your-ec2-public-ip>
     ```
   - Check the Jenkins initial admin password:
     ```bash
     sudo cat /var/lib/jenkins/secrets/initialAdminPassword
     ```
   - Copy the displayed password for later use.

3. **Access the Jenkins Web Interface**
   - Open a web browser and navigate to:
     ```
     http://<your-ec2-public-ip>:8080
     ```
   - Enter the initial admin password from Step 2.

4. **Complete the Jenkins Setup Wizard**
   - Install recommended plugins or select specific ones based on your needs.
   - Create your admin user and finish the configuration.

## Notes
- Make sure to replace `<your-key.pem>` and `<your-ec2-public-ip>` with your actual SSH key and EC2 instance IP address.
- For security, restrict access to the Jenkins server by configuring security group rules or enabling HTTPS.

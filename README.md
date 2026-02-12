### 🚀 Terraform + Ansible Automated EC2 Deployment

        This project provisions an AWS EC2 instance (t3.xlarge) using Terraform and automatically configures it with Nginx using Ansible, fully automated via GitHub Actions CI/CD pipeline.

        The deployment uses:
        
        ✅ Terraform for infrastructure provisioning
        
        ✅ Ansible for configuration management
        
        ✅ GitHub Actions for CI/CD
        
        ✅ AWS OIDC authentication (no static credentials)
        
        ✅ Default VPC & Subnet
        
        ✅ Secure SSH key injection via GitHub Secrets

## 📌 Architecture Overview
        GitHub Push (main)
                │
                ▼
        GitHub Actions Pipeline
                │
                ├── Configure AWS (OIDC Role)
                ├── Terraform Init & Apply
                ├── Extract EC2 Public IP (Output)
                ├── Inject SSH Key from Secrets
                └── Run Ansible → Install Nginx

##  🏗 Infrastructure Details

        Terraform provisions:
        
        EC2 Instance
        
        Instance Type: t3.xlarge
        
        OS: (AMI defined in Terraform)
        
        Key Pair attached
        
        EBS Volume
        
        Type: gp3
        
        Size: 30 GB
        
        Network
        
        Default VPC
        
        Default Subnet
        
        Public IP enabled
        
        Terraform Output:
        
        output "instance_public_ip" {
          value = aws_instance.app.public_ip
        }
        
        
        This output is consumed by GitHub Actions and passed to Ansible dynamically.

## 🔐 Authentication (Secure AWS Access)

        This project uses OIDC authentication instead of AWS access keys.
        
        GitHub Actions assumes an IAM Role:
        
        permissions:
          id-token: write
          contents: read
        
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::${{ secrets.AWS_ID }}:role/${{ secrets.AWS_ROLE_NAME }}
          aws-region: ${{ vars.REGION }}
        
        
        ✅ No hardcoded credentials
        ✅ Secure, modern authentication method

## 🔄 CI/CD Workflow

        The pipeline triggers on push to main branch:
        
        name: Terraform + Ansible Deploy
        
        on:
          push:
            branches: [ main ]

        #🔹 Pipeline Steps
        
        Checkout repository
        
        Configure AWS credentials (OIDC role)
        
        Setup Terraform
        
        terraform init
        
        terraform apply -auto-approve
        
        Extract EC2 public IP via Terraform output
        
        Create SSH private key file from GitHub Secret
        
        Install Ansible
        
        Run Ansible playbook
        
        🔑 Secure SSH Key Injection
        
        Instead of storing SSH keys in the repository:
        
        - name: create key file
          run: |
            mkdir -p ~/.ssh
            echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/aws.pem
            chmod 600 ~/.ssh/aws.pem
        
        
        SSH private key stored in GitHub Secrets
        
        Injected dynamically during pipeline runtime
        
        Removed after runner is destroyed

        🔒 Secure & compliant approach

        🤖 Ansible Deployment

        # The EC2 public IP is passed dynamically:
        
        - name: Get EC2 Public IP
          run: |
            echo "EC2_IP=$(terraform output -raw instance_public_ip)" >> $GITHUB_ENV
        
        
        Ansible is executed against that IP:
        
        ansible-playbook -i "$EC2_IP," install_nginx.yml
        
        
        The playbook installs and starts Nginx automatically.
        

## 🧠 Key DevOps Concepts Demonstrated

        Infrastructure as Code (IaC)
        
        Output variable consumption across tools
        
        CI/CD pipeline automation
        
        OIDC-based AWS authentication
        
        Secrets management
        
        Terraform + Ansible integration
        
        Ephemeral runners security model

## ▶️ How to Use
        
        Fork or clone repository
        
        Configure GitHub Secrets:
        
        AWS_ID
        
        AWS_ROLE_NAME
        
        SSH_PRIVATE_KEY
        
        Set Repository Variable:
        
        REGION
        
        Push to main branch

        Deployment runs automatically 🚀

## 🌍 Result

        After successful pipeline execution:
        
        EC2 instance is provisioned
        
        Nginx is installed and running
        
        Accessible via:
        
        http://<EC2_PUBLIC_IP>

# Laravel Application Deployment Pipeline

[![Deploy Laravel Application](https://img.shields.io/badge/Deploy-GitHub%20Actions-blue)](../../actions/workflows/deploy.yml)
[![Terraform](https://img.shields.io/badge/Terraform-v1.5+-purple)](https://terraform.io)
[![OWASP ZAP](https://img.shields.io/badge/Security-OWASP%20ZAP-orange)](https://owasp.org/www-project-zap/)

A production-ready Laravel deployment pipeline using **Terraform**, **GitHub Actions**, **AWS ECS Fargate**, with **OWASP ZAP** security scanning and **Blue-Green deployment** for zero downtime.

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        GitHub Actions                              │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────────────┐   │
│  │  Build  │ → │Push ECR │ → │OWASP ZAP│ → │Blue-Green Deploy│   │
│  └─────────┘   └─────────┘   └─────────┘   └─────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────┐
│                           AWS Cloud                                │
│  ┌─────────┐   ┌─────────────────────────────────────────────┐   │
│  │   ECR   │   │                    VPC                       │   │
│  │ Registry│   │  ┌───────────┐         ┌───────────────┐    │   │
│  └────┬────┘   │  │    ALB    │         │  Private Subnet│    │   │
│       │        │  │ (Blue/Grn)│         │ ┌───────────┐  │    │   │
│       │        │  └─────┬─────┘         │ │ ECS Fargate│  │    │   │
│       │        │        │               │ │  (Laravel) │  │    │   │
│       └────────┼────────┼───────────────┼─┤            │  │    │   │
│                │        │               │ └───────────┘  │    │   │
│                │        │               │ ┌───────────┐  │    │   │
│                │        │               │ │  RDS MySQL │  │    │   │
│                │        │               │ └───────────┘  │    │   │
│                │  ┌─────┴─────┐         └───────────────┘    │   │
│                │  │ CodeDeploy│                               │   │
│                │  │ (Traffic) │                               │   │
│                │  └───────────┘                               │   │
│                └─────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5.0
- Docker (for local testing)
- GitHub repository with Actions enabled

### Step 1: Bootstrap Terraform Backend

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

### Step 2: Configure GitHub OIDC

```bash
cd terraform
# Edit github-oidc.tf with your GitHub org/repo
terraform init
terraform apply -target=aws_iam_openid_connect_provider.github -target=aws_iam_role.github_actions
```

### Step 3: Deploy Infrastructure

```bash
# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Initialize and apply
terraform init
terraform plan
terraform apply
```

### Step 4: Push to GitHub

```bash
git add .
git commit -m "Initial deployment setup"
git push origin main
```

The GitHub Actions workflow will automatically:
1. ✅ Build and test the Laravel application
2. ✅ Build Docker image and push to ECR
3. ✅ Run OWASP ZAP security scan
4. ✅ Deploy using Blue-Green strategy

## 📁 Project Structure

```
.
├── .github/
│   ├── workflows/
│   │   └── deploy.yml        # CI/CD pipeline
│   └── zap-rules.tsv         # OWASP ZAP configuration
│
├── app/weblog/               # Laravel application
│   ├── Dockerfile            # Multi-stage Docker build
│   ├── docker-compose.yml    # Local development
│   └── docker/               # Container configurations
│       ├── nginx.conf
│       ├── nginx-site.conf
│       ├── php.ini
│       └── supervisord.conf
│
└── terraform/
    ├── main.tf               # Root module
    ├── variables.tf          # Input variables
    ├── outputs.tf            # Output values
    ├── providers.tf          # AWS provider
    ├── backend.tf            # S3 state backend
    ├── terraform.tfvars.example
    │
    ├── bootstrap/            # State backend setup (run first)
    │   └── main.tf
    │
    ├── github-oidc/          # GitHub Actions OIDC (run second)
    │   └── main.tf
    │
    └── modules/
        ├── vpc/              # VPC, subnets, NAT
        ├── ecr/              # Container registry
        ├── rds/              # MySQL database
        ├── alb/              # Load balancer (Blue/Green)
        ├── ecs/              # Fargate cluster & service
        ├── security/         # Security groups
        └── codedeploy/       # Blue-Green deployment
```

## 🔐 Security Features

- **OWASP ZAP Scanning**: Automated security scan on every deployment
- **OIDC Authentication**: No long-lived AWS credentials in GitHub
- **Private Subnets**: ECS tasks and RDS in private subnets
- **Encrypted Storage**: RDS encryption at rest
- **Security Groups**: Strict ingress/egress rules
- **ECR Image Scanning**: Vulnerability scanning on push

## 🔄 Blue-Green Deployment

The deployment uses AWS CodeDeploy with:
- **Linear 10% Traffic Shift**: Every 1 minute
- **Automatic Rollback**: On deployment failure
- **Health Checks**: Validation at each traffic shift
- **5-minute Bake Time**: After full traffic shift

## 📊 Outputs

After deployment, Terraform outputs:
- `application_url`: Your application URL
- `ecr_repository_url`: ECR repository for pushing images
- `alb_dns_name`: Load balancer DNS name
- `ecs_cluster_name`: ECS cluster name

## 🛠️ Local Development

```bash
cd app/weblog

# Generate app key
php artisan key:generate

# Start containers
docker-compose up -d

# Access at http://localhost:8080
```

## 📝 Environment Variables

Required in `terraform.tfvars`:

| Variable | Description |
|----------|-------------|
| `db_password` | RDS master password |
| `app_key` | Laravel APP_KEY (base64) |

## 🧹 Cleanup

```bash
cd terraform
terraform destroy
```

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

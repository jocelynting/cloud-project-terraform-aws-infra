This project provides Terraform configurations for deploying AWS infrastructure for a web application, along with auxiliary tools for API testing and evaluation (a Go-based grader and Python scripts).

## Features

- **AWS Infrastructure**

  - Creates VPC, subnets, security groups, IAM roles and policies, as well as EC2 instances.
  - Configures CloudWatch VPC endpoints for monitoring and logging.

- **Networking**

  - Implements Route 53 DNS records for API access.
  - Sets up a Network Load Balancer (NLB) with target groups and listeners.

- **Security & Monitoring**

  - Establishes IAM roles and instance profiles for EC2 instances to enable monitoring and SSM.
  - Uses user data scripts to set environment variables during instance initialization.

- **Automated Testing & Evaluation**
  - Includes a Go-based grader for performing API health checks and endpoint validations.
  - Provides Python scripts for result verification and environment setup.
  - Contains unit tests for web application API endpoints utilizing pytest.

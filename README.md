# Cloud Resume Infrastructure

This repository contains the Infrastructure as Code (IaC) implementation for the **Cloud Resume Challenge**. It provisions a fully serverless web application on AWS using **Terraform**, with a static frontend hosted in S3 and a backend powered by API Gateway, Lambda, and DynamoDB.

## Architecture

- **Amazon S3** – hosts the static website (HTML, CSS, JS).
- **Amazon CloudFront** – provides global CDN distribution with HTTPS support.
- **AWS Certificate Manager (ACM)** – issues TLS certificates for secure connections.
- **Amazon Route 53** – manages DNS records for the custom domain.
- **Amazon API Gateway** – exposes a REST API for the visitor counter.
- **AWS Lambda** – serverless functions for handling counter logic.
- **Amazon DynamoDB** – stores visitor counts in a NoSQL table.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0  
- An AWS account with sufficient permissions  
- A registered domain in Route 53 (for SSL + CloudFront)  
- Configured AWS CLI credentials  

## Deployment

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/cloud-resume-infra.git
   cd cloud-resume-infra
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Preview the infrastructure changes:
   ```bash
   terraform plan
   ```

4. Apply the changes:
   ```bash
   terraform apply
   ```

   Confirm with `yes` when prompted.

## Project Structure

```
cloud-resume-infra/
├── acm.tf              # Certificate Manager configuration
├── apigateway.tf       # API Gateway setup
├── backend.tf          # Terraform backend configuration
├── cloudfront.tf       # CloudFront distribution
├── dns.tf              # Route 53 DNS records
├── dynamodb.tf         # DynamoDB table
├── getVisitCounter.tf  # Lambda for reading visitor count
├── visitCounter.tf     # Lambda for updating visitor count
├── s3.tf               # S3 static website hosting
├── variables.tf        # Input variables
├── site/               # Static website (HTML, CSS, JS)
```

## Frontend

- The website is located in the `site/` directory.  
- It includes:
  - `index.html` – Resume page  
  - `resume.css` – Stylesheet  
  - `script.js.tpl` – JavaScript template for API integration  

## Backend

- **Lambda Functions** (`visitCounter.zip`, `getVisitCounter.zip`) handle DynamoDB read/write operations.  
- API Gateway exposes endpoints consumed by the frontend JS.  

## Notes

- Make sure your domain is properly delegated to Route 53 before applying Terraform.  
- ACM certificates must be created in the `us-east-1` region for CloudFront.  

## License

This project is licensed under the MIT License.

# k8s-iac

&nbsp; 본 저장소는 Terraform을 사용하여 AWS k8s 인프라를 구축하고 관리하는 저장소이다.

## Tech Stack

- Terraform 1.0.0+
- AWS (VPC, EKS, EC2, RDS 등)
- Kubernetes

## Architecture

...

### Build & Run

#### 1. `backend.hcl` 생성 (예시)

```hcl
bucket         = "k8s-tfstate"
key            = "terraform.tfstate"
region         = "ap-northeast-2"
dynamodb_table = "k8s-tfstate-lock"
encrypt        = true
```

#### 2. 프로젝트 시작

```bash
terraform init -backend-config=backend.hcl
```

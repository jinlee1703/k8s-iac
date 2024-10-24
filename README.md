# k8s-iac

&nbsp; 본 저장소는 Terraform을 사용하여 AWS k8s 인프라를 구축하고 관리하는 저장소이다.

## Tech Stack

- Terraform 1.0.0+
- AWS (VPC, EC2 등)
- Kubernetes

## Architecture

```gherkin
+------------------------------------------------------+
|                      AWS Cloud                       |
|                                                      |
|  +------------------------+     +------------------+ |
|  |         VPC            |     |     S3 Bucket    | |
|  |                        |     | (Terraform State)| |
|  |  +------------------+  |     +------------------+ |
|  |  |     Subnets      |  |                          |
|  |  |                  |  |                          |
|  |  | +----+  +----+   |  |                          |
|  |  | | EC2|  | EC2|   |  |                          |
|  |  | +----+  +----+   |  |                          |
|  |  +------------------+  |                          |
|  |                        |                          |
|  |  +------------------+  |                          |
|  |  |     EKS Cluster  |  |                          |
|  |  |                  |  |                          |
|  |  |  +------------+  |  |                          |
|  |  |  |   Worker   |  |  |                          |
|  |  |  |   Nodes    |  |  |                          |
|  |  |  +------------+  |  |                          |
|  |  +------------------+  |                          |
|  |                        |                          |
|  +------------------------+                          |
|                                                      |
+------------------------------------------------------+
```

### 환경 간 의존성

- 각 환경(개발, 스테이징, 프로덕션 등)은 `environments/<환경명>/main.tf` 파일에서 관리한다.
- 환경별 `main.tf`는 `modules` 디렉토리의 필요한 모듈을 호출하여 인프라를 구성한다.

## Directories

```plaintext
.
├── modules/
│ ├── networking/
│ ├── security/
│ ├── compute/
│ └── database/
├── environments/
│ ├── dev/
│ ├── staging/
│ └── prod/
├── main.tf
├── variables.tf
├── outputs.tf
└── backend.hcl
```

- `modules/`: 재사용 가능한 모든 모듈을 포함
- `environments/`: 각 환경별 설정을 포함
- `./(root)`: 전체 프로젝트 관리

## 시작하기

### 1. `backend.hcl` 파일 생성

```hcl
bucket         = "k8s-tfstate"
key            = "terraform.tfstate"
region         = "ap-northeast-2"
dynamodb_table = "k8s-tfstate-lock"
encrypt        = true
```

### 2. 프로젝트 초기화

```bash
terraform init -backend-config=backend.hcl
```

### 3. 인프라 계획 확인

```bash
terraform plan
```

### 4. 인프라 적용

```bash
terraform apply
```

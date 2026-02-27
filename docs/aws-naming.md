# SWK AWS Naming Convention

> TeamSPWK AWS 리소스 네이밍 표준. 새 프로젝트/리소스 생성 시 이 규칙을 따른다.

## 패턴

```
{project}-{env}-{resource}-{detail}
```

| 요소 | 규칙 | 예시 |
|------|------|------|
| project | 프로젝트 약어 (소문자) | `lbd`, `bpc`, `ccm`, `tekt` |
| env | `prod`, `stg`, `dev` | `prod` |
| resource | AWS 리소스 타입 약어 | `ec2`, `rds`, `s3`, `sg`, `vpc` |
| detail | 용도 설명 (선택) | `api`, `web`, `worker`, `db` |

## 리소스별 예시

| 리소스 | 네이밍 패턴 | 예시 |
|--------|------------|------|
| EC2 | `{project}-{env}-{role}` | `lbd-prod-api`, `bpc-dev-worker` |
| RDS | `{project}-{env}-db` | `lbd-prod-db`, `ccm-stg-db` |
| S3 | `swk-{project}-{env}-{purpose}` | `swk-lbd-prod-assets`, `swk-bpc-dev-uploads` |
| EKS Cluster | `{project}-{env}-eks` | `lbd-prod-eks` |
| Security Group | `{project}-{env}-sg-{role}` | `lbd-prod-sg-api`, `bpc-dev-sg-db` |
| IAM User | `{project}-{purpose}` | `lbd-github-action`, `bpc-deploy` |
| Lambda | `{project}-{env}-{function}` | `lbd-prod-image-resize` |
| CloudFront | `{project}-{env}-cf` | `lbd-prod-cf` |
| VPC | `{project}-{env}-vpc` | `lbd-prod-vpc` |
| Subnet | `{project}-{env}-{public|private}-{az}` | `lbd-prod-private-2a` |

## NCP 리소스

NCP는 `tekt-` prefix 사용 (TEKT 프로젝트 전용).

| 리소스 | 네이밍 | 예시 |
|--------|--------|------|
| Server | `tekt-{role}` | `tekt-gpu`, `tekt-api` |
| VPC | `tekt-vpc` | `tekt-vpc` |
| Subnet | `tekt-subnet-{zone}` | `tekt-subnet-kr2` |
| ACG | `tekt-{role}-acg` | `tekt-gpu-acg` |

## 태그 표준

모든 AWS 리소스에 최소 아래 태그를 부여한다:

| 태그 키 | 값 | 필수 |
|---------|-----|------|
| `Name` | 네이밍 규칙에 따른 이름 | O |
| `Project` | 프로젝트명 (`lbd`, `bpc`, `ccm`) | O |
| `Environment` | `prod`, `stg`, `dev` | O |
| `Owner` | 담당자 (`keunsik`, `team`) | O |
| `ManagedBy` | `manual`, `terraform`, `cdk` | - |

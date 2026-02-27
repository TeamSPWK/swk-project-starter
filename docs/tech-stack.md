# SWK Tech Stack Standards

> TeamSPWK 기술 스택 **권장** 사항. 프로젝트 특성에 따라 다른 선택도 가능합니다.
> 예: AI/ML 프로젝트는 Python, 데이터 파이프라인은 Go 등

## Converged Stack (2026 Q1 기준)

### Frontend

| 기술 | 버전 | 비고 |
|------|------|------|
| Next.js | 15+ (App Router) | Pages Router 사용 금지 |
| React | 19+ | Server Components 우선 |
| TypeScript | 5+ | strict mode |
| Tailwind CSS | 4+ | CSS-in-JS 사용 금지 |
| 상태관리 | Zustand + React Query | Redux 사용 금지 (신규) |
| 아이콘 | Lucide React | |
| 패키지매니저 | pnpm | npm/yarn 사용 금지 (신규) |

### Backend

| 기술 | 버전 | 비고 |
|------|------|------|
| **Option A**: Next.js API Routes | 15+ | 소규모 프로젝트 |
| **Option B**: Spring Boot (Kotlin) | 3+ | AI/ML 연동, 대규모 |
| **Option C**: Supabase | - | MVP/빠른 프로토타입 |
| **Option D**: Python (FastAPI/Django) | 3.11+ | AI/ML, 데이터 처리 |
| ORM | Prisma 7+ (Node) / JPA (Kotlin) / SQLAlchemy (Python) | |
| DB | PostgreSQL 15+ | PostGIS 필요 시 확장 |

### Infrastructure

| 기술 | 용도 | 비고 |
|------|------|------|
| AWS | 프로덕션 | Seoul (ap-northeast-2) |
| NCP | GPU 서버 | KR-1, KR-2 |
| GitHub Actions | CI/CD | |
| ArgoCD | Kubernetes CD | EKS 환경 |
| Docker | 컨테이너 | |

## 프로젝트 레벨별 추천

### Starter (정적 사이트, 랜딩페이지)
- Next.js 15 + Tailwind CSS 4
- Vercel 배포
- DB 없음

### Dynamic (로그인, DB 있는 웹앱)
- Next.js 15 + Tailwind CSS 4 + Zustand + React Query
- Prisma 7 + PostgreSQL 또는 Supabase
- AWS (EC2/EKS) 또는 Vercel + 외부 DB

### Enterprise (마이크로서비스, 대규모)
- Turborepo 모노레포
- Next.js 15 (프론트) + Spring Boot (백엔드)
- EKS + ArgoCD + Terraform
- PostgreSQL + Redis + ElasticSearch

## 금지 목록 (신규 프로젝트)

| 기술 | 이유 | 대안 |
|------|------|------|
| Create React App | 더 이상 유지보수 안됨 | Next.js |
| Redux | 보일러플레이트 과다 | Zustand |
| styled-components | SSR 이슈 + 성능 | Tailwind CSS |
| npm / yarn | 팀 표준은 pnpm | pnpm |
| Pages Router | 레거시 | App Router |
| JavaScript (no TS) | 타입 안전성 | TypeScript |

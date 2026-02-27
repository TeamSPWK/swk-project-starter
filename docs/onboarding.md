# TeamSPWK 프로젝트 시작 가이드

> 이 문서는 이 템플릿으로 새 프로젝트를 시작할 때 따르는 가이드입니다.
> 관리자: 근식 (keunsik)

---

## 1. 프로젝트 초기 설정

### Step 1: CLAUDE.md 커스터마이징

`CLAUDE.md`의 `{{변수}}`를 실제 값으로 바꿉니다:

```
{{PROJECT_NAME}}        → 프로젝트명 (예: my-new-app)
{{PROJECT_DESCRIPTION}} → 설명 한 줄
{{CLOUD_PROVIDER}}      → AWS / NCP / AWS + NCP / 없음
{{PROJECT_KEY}}         → 시크릿 경로 (예: aws/my-new-app)
```

클라우드를 사용하지 않으면 Credentials 섹션을 삭제하세요.

### Step 2: 패키지 설치 + 개발 시작

```bash
pnpm install
pnpm dev
```

### Step 3: 근식님에게 등록 요청

새 프로젝트는 중앙 관리 레지스트리에 등록해야 합니다.
Slack으로 아래 정보를 전달하세요:

```
프로젝트명: my-new-app
GitHub 레포: TeamSPWK/my-new-app
설명: ~~~~
레벨: Starter / Dynamic / Enterprise
클라우드: AWS / NCP / 둘 다 / 없음
주요 스택: next15, typescript, tailwind4, ...
담당자: 본인 이름
```

---

## 2. Claude Code 사용법

### 기본 명령어

| 명령어 | 설명 |
|--------|------|
| `/dev` | 개발 서버 시작 |
| `/build` | 프로덕션 빌드 + 타입 체크 |
| `/lint` | ESLint + Prettier 검사 |

### 자동 안전장치 (.claude/settings.json)

이 프로젝트에는 아래 명령어가 자동 차단됩니다:
- `rm -rf /`, `rm -rf .` — 전체 삭제
- `.env` 파일 접근 — 자격증명 보호
- `git push --force` — 강제 푸시
- `git reset --hard` — 되돌리기 불가 리셋
- `--no-verify` — hooks 스킵

### 경로별 규칙 (.claude/rules/)

파일을 수정할 때 해당 경로의 규칙이 자동 적용됩니다:

```
rules/src.md → src/** 수정 시: Server Components 우선, Tailwind 사용
```

프로젝트에 맞게 규칙을 추가할 수 있습니다:
```markdown
# .claude/rules/api.md
---
paths:
  - "src/app/api/**"
---
## API Rules
- 모든 API는 에러 핸들링 필수
- 응답은 { data, error, message } 형식
```

### Known Mistakes 활용

`CLAUDE.md` 하단의 Known Mistakes 섹션에 실수를 기록하면 Claude가 반복하지 않습니다:

```markdown
## Known Mistakes
- prisma generate 안 하고 타입 에러 → 스키마 변경 후 항상 prisma generate
```

---

## 3. AWS/NCP 리소스 규칙

### 승인 프로세스

AWS/NCP 리소스를 **생성, 수정, 삭제**할 때는 근식님 승인이 필요합니다.

**방법 1: Slack에서 직접 요청**
```
#swk-infra 채널:
"EC2 생성 요청: lbd-prod-worker, t3.medium, ap-northeast-2a"
→ 근식님 승인 후 진행
```

**방법 2: approval-request.sh 사용**
```bash
# Slack webhook 설정 후
./scripts/approval-request.sh "create" "EC2 instance" "t3.medium, lbd-prod-worker"
```

### 네이밍 규칙

상세: `docs/aws-naming.md`

```
{project}-{env}-{resource}-{detail}
예: lbd-prod-api, swk-bpc-dev-uploads
```

### 태그 필수 (모든 AWS 리소스)

| 태그 | 예시 | 필수 |
|------|------|------|
| `Name` | lbd-prod-api | O |
| `Project` | lbd | O |
| `Environment` | prod / stg / dev | O |
| `Owner` | 본인 이름 | O |

---

## 4. 글로벌 Claude Code 설정

팀원 각자의 머신에서 글로벌 규칙을 설정하면, 모든 프로젝트에 공통 적용됩니다:

```bash
mkdir -p ~/.claude
cat > ~/.claude/CLAUDE.md << 'EOF'
# SWK Global Rules

## 응답
- 한국어로 응답

## 안전
- AWS/NCP 리소스 생성·삭제·수정 전 반드시 사용자 확인
- .env, .secret/ 절대 커밋 금지

## 커밋
- 영문 타입 prefix + 한국어 본문 (feat: 로그인 기능 추가)

## 작업 방식
- 3개 이상 파일 수정 → 계획 먼저 제시, 승인 후 구현
- 모르는 것은 추측하지 말고 물어보기

## 코드 스타일
- ESLint + Prettier에 위임
EOF
```

---

## 5. 문제 해결

| 상황 | 해결 |
|------|------|
| Claude가 영어로 답함 | CLAUDE.md에 "한국어로 응답" 확인 |
| 위험 명령이 실행됨 | .claude/settings.json deny 목록 확인 |
| TypeScript 에러를 못 잡음 | .claude/hooks/lint-check.sh 확인 |
| 빌드가 CI에서만 실패 | 로컬에서 `pnpm build` 먼저 실행 |
| AWS 자격증명 에러 | `eval $(./scripts/load-secret.sh aws/...)` 실행 |

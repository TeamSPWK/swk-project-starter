# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Language

- Claude는 사용자에게 항상 **한국어**로 응답한다.

## Tech Stack

| 영역 | 기술 |
|------|------|
| Frontend | Next.js 15 (App Router), React 19, TypeScript 5 |
| Styling | Tailwind CSS 4, Lucide React |
| Package | pnpm |
| Cloud | {{CLOUD_PROVIDER}} |
| CI/CD | GitHub Actions |

상세 표준: `docs/tech-stack.md` | 금지 기술 목록 포함

## Principles

- **정확도 > 속도**: 추측하지 않는다. 에러 메시지를 정확히 읽는다
- **변경 전 확인**: 클라우드 리소스 수정/삭제는 반드시 사용자 확인 후 실행
- **코드 스타일은 린터에 위임**: ESLint + Prettier 설정을 따른다
- **3개 이상 파일 수정 시 계획 먼저 제시**

## Credentials

```bash
# AWS (해당 시)
eval $(./scripts/load-secret.sh aws/{{PROJECT_KEY}})

# NCP (해당 시)
eval $(./scripts/load-secret.sh ncp/{{PROJECT_KEY}})
```

## Project Structure

```
{{PROJECT_NAME}}/
├── CLAUDE.md              # 이 파일 - 프로젝트 컨텍스트
├── docs/                  # 팀 표준 문서
│   ├── onboarding.md      # 프로젝트 시작 가이드 (필독)
│   ├── aws-naming.md      # AWS/NCP 리소스 네이밍 + 태그 규칙
│   └── tech-stack.md      # 기술 스택 표준 + 금지 목록
├── scripts/               # 유틸리티 스크립트
│   ├── slack-notify.sh    # Slack 알림 (info/warning/approval/deploy)
│   └── approval-request.sh # 인프라 변경 승인 요청
├── src/                   # 소스 코드
├── .claude/               # Claude Code 설정
│   ├── settings.json      # 안전 규칙 (위험 명령 차단 + 인프라 알림)
│   ├── hooks/
│   │   ├── lint-check.sh  # TypeScript 자동 문법 검증
│   │   └── infra-guard.sh # 인프라 변경 감지 → Issue + Slack 알림
│   ├── rules/src.md       # src/** 코딩 규칙
│   └── commands/          # /dev, /build, /lint
└── .github/workflows/     # CI/CD
```

## Commands

| 명령어 | 설명 |
|--------|------|
| `/dev` | 개발 서버 시작 |
| `/build` | 프로덕션 빌드 + 타입 체크 |
| `/lint` | ESLint + Prettier 검사 |

## AWS/NCP 리소스 규칙

- **네이밍**: `{project}-{env}-{resource}-{detail}` (상세: `docs/aws-naming.md`)
- **태그 필수**: Name, Project, Environment, Owner
- **승인**: 생성/수정/삭제 시 근식님(@keunsik) 승인 필요
- **자동 알림**: infra-guard hook이 AWS/NCP 변경을 감지하면:
  - `TeamSPWK/swk-cloud-manage`에 GitHub Issue 자동 생성
  - Slack webhook 설정 시 #swk-infra 채널 알림

## Git Convention

```
feat: 새 기능 추가  |  fix: 버그 수정  |  update: 기존 기능 개선
refactor: 리팩토링  |  chore: 설정/기타  |  docs: 문서 수정
```

## Critical Rules

> 위반 시 사고 가능. 반드시 지킨다.

1. **클라우드 리소스 변경 전 반드시 사용자 확인** — 자동 알림이 가지만 승인은 별도
2. **`.env`, `.secret/` 절대 git 커밋 금지**
3. **프로덕션 DB에 직접 쿼리 금지** (읽기 전용도 확인 후)
4. **main 브랜치 force push 금지**

## Known Mistakes

실수를 반복하지 않기 위한 기록.

- (프로젝트 진행하면서 추가)

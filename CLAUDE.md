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
├── CLAUDE.md          # 이 파일
├── src/               # 소스 코드
├── scripts/           # 유틸리티 스크립트
├── .claude/           # Claude Code 설정
│   ├── rules/         # 경로별 자동 규칙
│   ├── hooks/         # 자동 검증 훅
│   └── commands/      # 커스텀 슬래시 명령어
└── .github/workflows/ # CI/CD
```

## Commands

| 명령어 | 설명 |
|--------|------|
| `/dev` | 개발 서버 시작 |
| `/build` | 프로덕션 빌드 + 타입 체크 |
| `/lint` | ESLint + Prettier 검사 |

## Git Convention

```
feat: 새 기능 추가  |  fix: 버그 수정  |  update: 기존 기능 개선
refactor: 리팩토링  |  chore: 설정/기타  |  docs: 문서 수정
```

## Critical Rules

> 위반 시 사고 가능. 반드시 지킨다.

1. **클라우드 리소스 변경 전 반드시 사용자 확인**
2. **`.env`, `.secret/` 절대 git 커밋 금지**
3. **프로덕션 DB에 직접 쿼리 금지** (읽기 전용도 확인 후)
4. **main 브랜치 force push 금지**

## Known Mistakes

실수를 반복하지 않기 위한 기록.

- (프로젝트 진행하면서 추가)

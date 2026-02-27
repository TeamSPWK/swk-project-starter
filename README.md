# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Quick Start

```bash
pnpm install
pnpm dev
```

처음이라면 `docs/onboarding.md`부터 읽어주세요.

## 포함된 문서

| 문서 | 설명 |
|------|------|
| `docs/onboarding.md` | 프로젝트 시작 가이드 (Step 1~4) |
| `docs/tech-stack.md` | 기술 스택 표준 + 금지 목록 |
| `docs/aws-naming.md` | AWS/NCP 리소스 네이밍 + 태그 규칙 |

## 포함된 스크립트

| 스크립트 | 설명 |
|---------|------|
| `scripts/slack-notify.sh` | Slack 알림 (info/warning/approval/deploy) |
| `scripts/approval-request.sh` | 인프라 변경 승인 요청 → Slack + CLI |

## Claude Code 설정

이 프로젝트는 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 최적화 설정이 포함되어 있습니다.

| 설정 | 설명 |
|------|------|
| `CLAUDE.md` | 프로젝트 컨텍스트 ({{변수}} 커스터마이징) |
| `.claude/settings.json` | 안전 규칙 (위험 명령 차단) |
| `.claude/hooks/lint-check.sh` | TypeScript 자동 문법 검증 |
| `.claude/hooks/infra-guard.sh` | 인프라 변경 감지 → Issue + Slack 알림 |
| `.claude/rules/src.md` | src/** 코딩 규칙 |
| `.claude/commands/` | `/dev`, `/build`, `/lint` |
| `.github/workflows/ci.yml` | pnpm CI 파이프라인 |

## 인프라 알림 자동화

AWS/NCP 리소스를 변경하는 명령이 감지되면:
1. **GitHub Issue** → `TeamSPWK/swk-cloud-manage`에 자동 생성
2. **Slack 알림** → Webhook 설정 시 #swk-infra 채널 알림

근식님(@keunsik)이 Issue/Slack으로 변경 내역을 확인하고 관리합니다.

## License

Private - TeamSPWK

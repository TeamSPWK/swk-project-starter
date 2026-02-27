# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Quick Start

```bash
pnpm install
pnpm dev
```

## Tech Stack

- Next.js 15 (App Router)
- React 19
- TypeScript 5
- Tailwind CSS 4
- pnpm

## Scripts

| 명령어 | 설명 |
|--------|------|
| `pnpm dev` | 개발 서버 (http://localhost:3000) |
| `pnpm build` | 프로덕션 빌드 |
| `pnpm lint` | ESLint 검사 |
| `pnpm format` | Prettier 포맷 |

## Claude Code

이 프로젝트는 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 최적화 설정이 포함되어 있습니다.

- `CLAUDE.md` - 프로젝트 컨텍스트
- `.claude/rules/` - 경로별 자동 규칙
- `.claude/hooks/` - 자동 검증 (TypeScript 문법)
- `.claude/commands/` - `/dev`, `/build`, `/lint`

## License

Private - TeamSPWK

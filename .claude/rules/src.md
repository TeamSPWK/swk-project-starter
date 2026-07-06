---
paths:
  - "src/**"
---
## Source Code Rules

- Server Components 우선. "use client"는 상호작용 필요 시에만
- **동적 API는 async** — `params`·`searchParams`·`cookies()`·`headers()`·`draftMode()`는 Promise다. 반드시 `await`
- 라우팅 미들웨어는 `proxy.ts` (구 `middleware.ts` — 최신 Next 에서 rename, edge 런타임 필요 시에만 middleware 유지)
- 스타일: Tailwind CSS. 인라인 style 사용 금지
- 새 패키지 설치 전 이유 + 대안 설명
- 컴포넌트는 함수 선언(function) 방식
- 변경 후 `pnpm build`(Turbopack) + `pnpm lint`(ESLint flat config) 성공 확인

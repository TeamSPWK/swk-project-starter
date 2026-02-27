코드 품질을 검사한다.

1. `pnpm lint`를 실행하여 ESLint 검사를 수행한다.
2. `pnpm format:check`를 실행하여 Prettier 포맷 검사를 수행한다.
   - `format:check` 스크립트가 없으면 건너뛴다.
3. 문제가 발견되면:
   - 자동 수정 가능한 항목을 분류한다.
   - `pnpm lint --fix` 또는 `pnpm format`으로 자동 수정할지 사용자에게 묻는다.
4. 모든 검사 통과 시 결과를 알려준다.

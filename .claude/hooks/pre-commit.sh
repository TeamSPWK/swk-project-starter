#!/bin/bash
# PostToolUse hook: git staged에 .env 파일이 포함되었는지 검사
# .env, .env.local 등이 커밋되는 것을 방지 (.env.example은 허용)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# git add/commit 관련 명령어인지 확인
if [[ "$COMMAND" == *"git add"* || "$COMMAND" == *"git commit"* ]]; then
  # staged 파일 목록 확인
  STAGED=$(git diff --cached --name-only 2>/dev/null || true)

  BLOCKED=""
  while IFS= read -r file; do
    # .env.example은 허용, 나머지 .env* 파일은 차단
    if [[ "$file" == .env && "$file" != .env.example ]] || \
       [[ "$file" == .env.* && "$file" != .env.example ]]; then
      BLOCKED="${BLOCKED}\n  - $file"
    fi
  done <<< "$STAGED"

  if [[ -n "$BLOCKED" ]]; then
    echo "🚨 환경변수 파일이 staged 영역에 포함되어 있습니다!"
    echo -e "차단된 파일:$BLOCKED"
    echo ""
    echo "다음 명령어로 제거하세요:"
    echo "  git reset HEAD <파일명>"
    exit 1
  fi
fi

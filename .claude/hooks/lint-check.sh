#!/bin/bash
# TypeScript/TSX 파일 수정 시 기본 문법 검증
# Claude Code PreToolUse hook — stdin JSON에서 파일 경로 추출
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -n "$FILE" && ("$FILE" == *.ts || "$FILE" == *.tsx) ]]; then
  if command -v npx &>/dev/null && [ -f "node_modules/.bin/tsc" ]; then
    npx tsc --noEmit --pretty 2>&1 | head -5
  fi
fi

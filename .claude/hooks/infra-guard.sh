#!/bin/bash
# SWK 인프라 가드 - AWS/NCP 리소스 변경 감지 시 알림
# Claude Code PreToolUse hook
#
# 동작:
# 1. Bash 명령어에서 AWS/NCP 리소스 변경 감지
# 2. swk-cloud-manage 레포에 GitHub Issue 생성
# 3. Slack 알림 전송 (webhook 설정 시)

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Bash 명령어만 검사
if [[ "$TOOL" != "Bash" || -z "$COMMAND" ]]; then
  exit 0
fi

# AWS 리소스 변경 패턴 감지
AWS_CHANGE=false
ACTION=""

if echo "$COMMAND" | grep -qE 'aws .+ (create-|delete-|terminate-|modify-|put-|update-)'; then
  AWS_CHANGE=true
  ACTION=$(echo "$COMMAND" | grep -oE '(create|delete|terminate|modify|put|update)-[a-z-]+' | head -1)
elif echo "$COMMAND" | grep -qE 'aws s3 (rm|rb|mv) '; then
  AWS_CHANGE=true
  ACTION="s3-$(echo "$COMMAND" | grep -oE '(rm|rb|mv)' | head -1)"
elif echo "$COMMAND" | grep -qE 'aws (iam|rds) '; then
  AWS_CHANGE=true
  ACTION=$(echo "$COMMAND" | grep -oE 'aws (iam|rds) [a-z-]+' | head -1)
elif echo "$COMMAND" | grep -qiE 'ncp_api_call.*(DELETE|create|delete)'; then
  AWS_CHANGE=true
  ACTION="ncp-resource-change"
fi

if [[ "$AWS_CHANGE" != "true" ]]; then
  exit 0
fi

# 프로젝트 정보
PROJECT_NAME=$(basename "$(pwd)")
REQUESTER=$(whoami)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# --- GitHub Issue 생성 (gh CLI 있으면) ---
if command -v gh &>/dev/null; then
  ISSUE_BODY="## 인프라 변경 감지

| 항목 | 값 |
|------|-----|
| **프로젝트** | $PROJECT_NAME |
| **작업** | \`$ACTION\` |
| **요청자** | $REQUESTER |
| **시간** | $TIMESTAMP |

### 실행 명령어
\`\`\`bash
$COMMAND
\`\`\`

> 이 이슈는 Claude Code infra-guard hook에 의해 자동 생성되었습니다."

  gh issue create \
    --repo TeamSPWK/swk-cloud-manage \
    --title "[infra] $PROJECT_NAME: $ACTION" \
    --body "$ISSUE_BODY" \
    --label "infra-change" \
    2>/dev/null &
fi

# --- Slack 알림 (webhook 있으면) ---
if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/scripts"
  if [[ -f "$SCRIPT_DIR/slack-notify.sh" ]]; then
    "$SCRIPT_DIR/slack-notify.sh" approval \
      "$PROJECT_NAME: $ACTION" \
      "명령어: $COMMAND | 요청자: $REQUESTER" \
      2>/dev/null &
  fi
fi

# hook은 명령어 실행을 차단하지 않음 - 알림만 보냄
exit 0

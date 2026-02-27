#!/bin/bash
set -euo pipefail

# SWK Slack 알림 스크립트
# Usage: ./scripts/slack-notify.sh <type> <message> [detail]
# Types: info, warning, approval, deploy
#
# 환경변수 필요:
#   SLACK_WEBHOOK_URL - Slack Incoming Webhook URL
#   (load-secret.sh external/slack 으로 로드)
#
# 예시:
#   ./scripts/slack-notify.sh info "docs/ 갱신 완료"
#   ./scripts/slack-notify.sh approval "EC2 인스턴스 생성 요청" "i-0abc123, t3.medium, lbd-prod-api"
#   ./scripts/slack-notify.sh warning "GuardDuty finding 발견" "High severity"

TYPE="${1:-info}"
MESSAGE="${2:-알림}"
DETAIL="${3:-}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)
PROJECT_DIR=$(basename "$(pwd)")

# Webhook URL 확인
if [[ -z "${SLACK_WEBHOOK_URL:-}" ]]; then
  echo "ERROR: SLACK_WEBHOOK_URL이 설정되지 않았습니다."
  echo "  eval \$(./scripts/load-secret.sh external/slack)"
  exit 1
fi

# 타입별 이모지 + 색상
case "$TYPE" in
  info)
    EMOJI=":information_source:"
    COLOR="#36a64f"
    ;;
  warning)
    EMOJI=":warning:"
    COLOR="#ff9900"
    ;;
  approval)
    EMOJI=":raised_hand:"
    COLOR="#ff0000"
    ;;
  deploy)
    EMOJI=":rocket:"
    COLOR="#4a90d9"
    ;;
  *)
    EMOJI=":bell:"
    COLOR="#cccccc"
    ;;
esac

# Detail 블록 (있으면 추가)
DETAIL_BLOCK=""
if [[ -n "$DETAIL" ]]; then
  DETAIL_BLOCK=$(cat <<EOF
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "\`\`\`$DETAIL\`\`\`"
      }
    },
EOF
  )
fi

# Slack 메시지 전송
PAYLOAD=$(cat <<EOF
{
  "attachments": [
    {
      "color": "$COLOR",
      "blocks": [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "$EMOJI *[$TYPE] $MESSAGE*"
          }
        },
        $DETAIL_BLOCK
        {
          "type": "context",
          "elements": [
            {
              "type": "mrkdwn",
              "text": ":clock1: $TIMESTAMP | :computer: $HOSTNAME | :file_folder: $PROJECT_DIR"
            }
          ]
        }
      ]
    }
  ]
}
EOF
)

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H 'Content-type: application/json' \
  --data "$PAYLOAD" \
  "$SLACK_WEBHOOK_URL")

if [[ "$RESPONSE" == "200" ]]; then
  echo "Slack 알림 전송 완료 [$TYPE]: $MESSAGE"
else
  echo "ERROR: Slack 알림 전송 실패 (HTTP $RESPONSE)"
  exit 1
fi

#!/bin/bash
set -euo pipefail

# SWK 승인 요청 스크립트
# AWS/NCP 리소스 변경 시 Slack으로 승인 요청을 보내고 CLI에서 확인을 기다린다.
#
# Usage: ./scripts/approval-request.sh <action> <resource> [detail]
#
# 예시:
#   ./scripts/approval-request.sh "create" "EC2 instance" "t3.medium, lbd-prod-api"
#   ./scripts/approval-request.sh "delete" "S3 bucket" "swk-lbd-dev-temp"
#   ./scripts/approval-request.sh "modify" "Security Group" "sg-0abc123, 포트 443 추가"
#
# 환경변수:
#   SLACK_WEBHOOK_URL - Slack webhook (선택: 없으면 CLI만)
#   SWK_APPROVAL_SKIP - "true"면 승인 스킵 (개발환경 전용)

ACTION="${1:-unknown}"
RESOURCE="${2:-unknown resource}"
DETAIL="${3:-}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
REQUESTER=$(whoami)

echo ""
echo "=========================================="
echo "  SWK 리소스 변경 승인 요청"
echo "=========================================="
echo "  시간:   $TIMESTAMP"
echo "  작업:   $ACTION"
echo "  리소스: $RESOURCE"
if [[ -n "$DETAIL" ]]; then
  echo "  상세:   $DETAIL"
fi
echo "  요청자: $REQUESTER"
echo "=========================================="
echo ""

# Slack 알림 전송 (webhook 있으면)
if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  "$SCRIPT_DIR/slack-notify.sh" approval \
    "$ACTION: $RESOURCE" \
    "요청자: $REQUESTER | $DETAIL"
fi

# 개발환경 스킵 체크
if [[ "${SWK_APPROVAL_SKIP:-}" == "true" ]]; then
  echo "[DEV MODE] 승인 자동 통과"
  exit 0
fi

# CLI 확인
echo -n "이 작업을 승인하시겠습니까? (y/N): "
read -r ANSWER

if [[ "$ANSWER" =~ ^[Yy]$ ]]; then
  echo "승인됨. 작업을 진행합니다."

  # 승인 로그 기록
  LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/logs/approvals.log"
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "$TIMESTAMP | APPROVED | $ACTION | $RESOURCE | $DETAIL | $REQUESTER" >> "$LOG_FILE"

  exit 0
else
  echo "거부됨. 작업을 취소합니다."

  # 거부 로그 기록
  LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/logs/approvals.log"
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "$TIMESTAMP | DENIED | $ACTION | $RESOURCE | $DETAIL | $REQUESTER" >> "$LOG_FILE"

  exit 1
fi

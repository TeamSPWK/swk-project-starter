#!/bin/bash
set -euo pipefail

# 프로젝트 초기 설정 스크립트
# GitHub "Use this template"으로 복제한 후 실행
# 사용법: ./setup.sh

echo ""
echo "=========================================="
echo "  프로젝트 초기 설정"
echo "=========================================="
echo ""

# ─── 1. 프로젝트 정보 입력 ───

read -rp "프로젝트 이름 (예: my-awesome-app): " PROJECT_NAME
if [[ -z "$PROJECT_NAME" ]]; then
  echo "❌ 프로젝트 이름은 필수입니다."
  exit 1
fi

read -rp "프로젝트 설명: " PROJECT_DESCRIPTION
PROJECT_DESCRIPTION="${PROJECT_DESCRIPTION:-$PROJECT_NAME 프로젝트}"

echo ""
echo "─── 설정 확인 ───"
echo "  프로젝트 이름: $PROJECT_NAME"
echo "  설명: $PROJECT_DESCRIPTION"
echo ""
read -rp "이 설정으로 진행하시겠습니까? (Y/n): " CONFIRM
if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then
  echo "설정이 취소되었습니다."
  exit 0
fi

echo ""
echo "🔧 설정을 적용합니다..."
echo ""

# ─── 1.5 템플릿 레포 remote 확인 ───

ORIGIN_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$ORIGIN_URL" == *"swk-project-starter"* ]]; then
  echo "⚠️  origin이 템플릿 레포(swk-project-starter)를 가리키고 있습니다."
  echo "   clone이 아닌 'Use this template'으로 새 레포를 만들어야 합니다."
  echo ""
  read -rp "remote origin을 제거하시겠습니까? (Y/n): " REMOVE_REMOTE
  if [[ ! "$REMOVE_REMOTE" =~ ^[Nn]$ ]]; then
    git remote remove origin
    echo "  ✅ origin 제거 완료. 새 remote를 설정하세요:"
    echo "     git remote add origin https://github.com/TeamSPWK/$PROJECT_NAME.git"
  else
    echo "  ⚠️  주의: 이 상태로 push하면 템플릿 레포가 수정됩니다."
  fi
  echo ""
fi

# ─── 2. .template → 실제 파일 (sed 치환) ───

for template in CLAUDE.md.template README.md.template .gitignore.template; do
  if [ -f "$template" ]; then
    TARGET="${template%.template}"
    echo "  📄 $template → $TARGET"
    sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{PROJECT_DESCRIPTION}}|$PROJECT_DESCRIPTION|g" \
        "$template" > "$TARGET"
    rm "$template"
  fi
done

# ─── 3. .env.local 생성 ───

if [ -f ".env.example" ] && [ ! -f ".env.local" ]; then
  echo "  📄 .env.example → .env.local 복사"
  cp .env.example .env.local
fi

# ─── 4. 실행 권한 부여 ───

echo "  🔑 hooks 실행 권한 부여"
chmod +x .claude/hooks/*.sh 2>/dev/null || true

# ─── 5. Next.js 스캐폴딩 (선택) ───

echo ""
read -rp "Next.js 프로젝트를 생성하시겠습니까? (y/N): " SCAFFOLD

if [[ "$SCAFFOLD" =~ ^[Yy]$ ]]; then
  echo ""
  echo "📦 Next.js 프로젝트 생성 중..."
  if command -v pnpm &>/dev/null; then
    # create-next-app은 기존 파일이 있으면 거부하므로 임시 이동
    TMPDIR_BACKUP=$(mktemp -d)
    for item in .claude .env.example .env.local .github CLAUDE.md README.md .gitignore setup.sh; do
      [ -e "$item" ] && mv "$item" "$TMPDIR_BACKUP/"
    done

    pnpm create next-app . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm --no-turbopack 2>/dev/null
    NEXT_RESULT=$?

    # 원본 파일 복원 (Next.js가 만든 README.md, .gitignore 덮어쓰기)
    for item in "$TMPDIR_BACKUP"/*  "$TMPDIR_BACKUP"/.*; do
      [ -e "$item" ] && mv -f "$item" . 2>/dev/null
    done
    rmdir "$TMPDIR_BACKUP" 2>/dev/null

    if [ "$NEXT_RESULT" -ne 0 ]; then
      echo "⚠️  Next.js 생성 실패. 수동으로 실행하세요:"
      echo "  pnpm create next-app . --typescript --tailwind --eslint --app --src-dir --use-pnpm"
    fi
  else
    echo "⚠️  pnpm이 설치되어 있지 않습니다."
    echo "  npm install -g pnpm 후 다시 시도하세요."
  fi
fi

# ─── 6. setup.sh 자체 삭제 여부 ───

echo ""
read -rp "setup.sh를 삭제하시겠습니까? (초기 설정 완료 후 불필요) (Y/n): " DELETE_SETUP

if [[ ! "$DELETE_SETUP" =~ ^[Nn]$ ]]; then
  rm -f setup.sh
  echo "  🗑️  setup.sh 삭제 완료"
fi

# ─── 7. 결과 요약 ───

echo ""
echo "=========================================="
echo "  ✅ 초기 설정 완료!"
echo "=========================================="
echo ""
echo "  프로젝트: $PROJECT_NAME"
echo ""
echo "📋 다음 단계:"
if [[ ! "${SCAFFOLD:-}" =~ ^[Yy]$ ]]; then
  echo "  1. Next.js 프로젝트 생성:"
  echo "     pnpm create next-app . --typescript --tailwind --eslint --app --src-dir --use-pnpm"
  echo "  2. .env.local에 환경변수 값 채우기"
else
  echo "  1. .env.local에 환경변수 값 채우기"
fi
echo "  3. Claude Code로 개발 시작:"
echo "     claude"
echo ""
echo "  유용한 명령어:"
echo "    /dev        - 개발 서버 시작"
echo "    /build      - 프로덕션 빌드"
echo "    /lint       - 코드 품질 검사"
echo "    /setup-env  - 환경변수 설정 가이드"
echo ""

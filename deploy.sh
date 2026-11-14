#!/bin/bash
# 동네평 배포 스크립트 (Firebase 무료 Spark 요금제)
# 터미널에서:  bash ~/Desktop/dongnepyeong/deploy.sh
set -e
cd "$(dirname "$0")"
echo ""
echo "===== 동네평 배포를 시작합니다 ====="

# 1) 무료 버전에서 쓰지 않는 파일 정리 (지우지 않고 _to_delete 폴더로 옮김)
mkdir -p _to_delete/public
[ -d functions ] && mv functions _to_delete/ && echo "- functions 폴더 정리"
[ -f storage.rules ] && mv storage.rules _to_delete/ && echo "- storage.rules 정리"
[ -f public/auth.html ] && mv public/auth.html _to_delete/public/ && echo "- public/auth.html 정리"

# 2) Firebase 도구 준비
if command -v firebase >/dev/null 2>&1; then
  FB="firebase"
elif command -v npx >/dev/null 2>&1; then
  echo "- Node.js가 있어서 npx로 Firebase 도구를 씁니다 (처음엔 1~2분 걸려요)"
  FB="npx -y firebase-tools@latest"
else
  if [ ! -x ./.firebase-cli ]; then
    echo "- Firebase 도구를 내려받는 중… (약 100MB, 1~3분)"
    curl -fL --progress-bar -o ./.firebase-cli https://firebase.tools/bin/macos/latest
    chmod +x ./.firebase-cli
  fi
  FB="./.firebase-cli"
fi

# 3) 로그인 (이미 되어 있으면 넘어감)
echo ""
echo "===== 로그인 ====="
echo "브라우저가 열리면 yjs080210@gmail.com 계정을 고르고 '허용'을 눌러 주세요."
echo "'Allow Firebase to collect ... information?' 이라고 물으면 n 을 누르고 Enter 를 누르세요."
$FB login

# 4) 배포 (보안 규칙 + 앱)
echo ""
echo "===== 업로드 ====="
$FB deploy --project dongnepyeong --only firestore,hosting

echo ""
echo "===== 완료! 이 주소를 여세요: https://dongnepyeong.web.app ====="

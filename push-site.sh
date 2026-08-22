#!/bin/bash
# 扶阳中医馆官网 一键推送脚本
# 用法： ./push-site.sh "本次更新说明"
# 令牌存放：同目录 token.txt（仅含 ghp_ 一行，不提交 git）

set -e

DIR="/Users/yunding/WorkBuddy/2026-08-19-18-51-33/fuyang-clinic-site"
TOKEN_FILE="$DIR/token.txt"

if [ ! -f "$TOKEN_FILE" ]; then
  echo "❌ 找不到 token.txt，请把 GitHub 令牌(ghp_开头)写入该文件一行"
  exit 1
fi
GH_TOKEN="$(head -n1 "$TOKEN_FILE" | tr -d '[:space:]')"

cd "$DIR"

MSG="${1:-更新网站内容 $(date '+%Y-%m-%d %H:%M')}"

git add -A
if git diff --cached --quiet; then
  echo "✅ 无文件变更，无需提交"
else
  git commit -q -m "$MSG"
  echo "✅ 已提交: $MSG"
fi

env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY -u all_proxy -u ALL_PROXY \
GIT_HTTP_VERSION=1.1 git -c http.sslVerify=false \
push "https://$GH_TOKEN@github.com/hgtc166/fy.git" main

echo "🚀 推送完成，等待 30-60 秒后访问 https://hgtc166.github.io/fy/"

#!/usr/bin/env bash
# collect_server_info.sh
# 在服务器上运行这个脚本来收集项目和 nginx 的关键信息，输出到 server_report.txt
# 用法：bash scripts/collect_server_info.sh > server_report.txt

set -e

echo "===== 日期和用户 ====="
date
whoami
echo

echo "===== 当前工作目录 ====="
pwd
ls -la
echo

echo "===== Git 状态（若是 git 仓库） ====="
if command -v git >/dev/null 2>&1; then
  git rev-parse --abbrev-ref HEAD 2>/dev/null || true
  git status --porcelain 2>/dev/null || true
  git log -n 3 --pretty=format:'%h %ad %s' --date=short 2>/dev/null || true
else
  echo "git 未安装或不可用"
fi
echo

PROJECT_ROOT=$(pwd)

echo "===== dist 目录 (项目根/dist) ====="
if [ -d "$PROJECT_ROOT/dist" ]; then
  ls -la "$PROJECT_ROOT/dist" | sed -n '1,200p'
  echo
  echo "dist 总大小："
  du -sh "$PROJECT_ROOT/dist" || true
  echo
  echo "dist/videos 内容："
  ls -la "$PROJECT_ROOT/dist/videos" || echo "dist/videos 不存在"
else
  echo "dist 目录不存在"
fi
echo

echo "===== public/videos (源码 public) ====="
if [ -d "$PROJECT_ROOT/public/videos" ]; then
  ls -la "$PROJECT_ROOT/public/videos" || true
else
  echo "public/videos 不存在"
fi
echo

echo "===== /var/www/html (nginx 默认站点根) 内容摘要 ====="
if [ -d "/var/www/html" ]; then
  ls -la /var/www/html | sed -n '1,200p' || true
  echo
  echo "/var/www/html/videos 列表："
  ls -la /var/www/html/videos || echo "/var/www/html/videos 不存在"
else
  echo "/var/www/html 不存在或无权限访问"
fi
echo

echo "===== 检查 nginx 服务状态 ====="
if command -v systemctl >/dev/null 2>&1; then
  systemctl status nginx --no-pager || true
else
  echo "systemctl 不可用，可能非 systemd 系统"
fi
echo

echo "===== nginx 配置中 root 列表 (sites-enabled) ====="
if [ -d "/etc/nginx/sites-enabled" ]; then
  grep -R "root\s" /etc/nginx/sites-enabled -n || true
else
  echo "/etc/nginx/sites-enabled 不存在，显示 nginx -T 输出的前200行："
  nginx -T 2>/dev/null | sed -n '1,200p' || true
fi
echo

echo "===== curl 检查视频文件（本机） ====="
# 尝试检查两个常见 URL（你可以手动替换域名或端口）
for URL in "http://localhost/videos/video1.mp4" "http://localhost/videos/video1.mp4?t=$(date +%s)"; do
  echo "---- $URL ----"
  curl -I --max-time 5 "$URL" 2>/dev/null || echo "请求失败或超时"
  echo
done

echo "===== 最近 nginx error 日志尾部 ====="
if [ -f /var/log/nginx/error.log ]; then
  echo "----- last 100 lines of /var/log/nginx/error.log -----"
  sudo tail -n 100 /var/log/nginx/error.log || true
else
  echo "/var/log/nginx/error.log 不存在或无权限"
fi
echo

echo "===== npm run build 最近输出 (若能访问 npm) ====="
if command -v npm >/dev/null 2>&1; then
  echo "(仅列出 build 脚本是否存在并打印 package.json scripts)"
  cat package.json | sed -n '1,200p' 2>/dev/null | grep -n "\"build\"" -n || true
else
  echo "npm 不可用"
fi

echo "===== Done ====="

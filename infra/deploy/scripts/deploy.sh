#!/bin/bash

echo "🚀 배포 시작: $(date)"

# 프로젝트 디렉토리 이동
cd /home/ubuntu/app/infra/deploy || exit

echo "🔄 최신 코드 가져오는 중..."
git pull origin main

echo "🐳 최신 Docker 이미지 가져오는 중..."
docker-compose pull

echo "🔄 컨테이너 재시작 중..."
docker-compose up -d --force-recreate

echo "🧹 사용하지 않는 Docker 이미지 정리"
docker image prune -f

echo "✅ 배포 완료!"

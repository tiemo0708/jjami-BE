#!/bin/bash

echo "🚀 배포 시작: $(date)"

# 프로젝트 디렉토리 이동
cd /home/ubuntu/app/infra/deploy || exit

echo "🔄 최신 코드 가져오는 중..."
git pull origin main  # 필요하면 유지, 불필요하면 제거 가능

echo "🐳 최신 Docker 이미지 가져오는 중..."
docker-compose pull  # 운영에서는 항상 최신 이미지 가져오기

echo "🔄 컨테이너 재시작 중..."
docker-compose up -d --force-recreate  # 최신 이미지로 컨테이너 재시작

echo "🧹 사용하지 않는 Docker 이미지 정리"
docker image prune -f  # 오래된 이미지 삭제하여 디스크 공간 확보

echo "✅ 배포 완료!"

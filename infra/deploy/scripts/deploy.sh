#!/bin/bash

echo "🚀 배포 시작: $(date)"

# 프로젝트 디렉토리 이동
cd /home/ubuntu/app/infra/deploy || exit

echo "🛑 기존 컨테이너 중지 중..."
docker-compose down  # 모든 기존 컨테이너 중지 및 제거

echo "🐳 최신 Docker 이미지 가져오는 중..."
docker-compose pull  # 최신 이미지 가져오기

echo "🔄 컨테이너 재시작 중..."
docker-compose up -d --force-recreate  # 최신 이미지로 컨테이너 재시작

echo "🧹 사용하지 않는 Docker 이미지 정리"
docker image prune -f  # 불필요한 이미지 정리

echo "🔄 Nginx 설정 반영 중..."
docker exec deploy-nginx nginx -s reload  # 변경된 설정 반영

echo "🔄 Certbot SSL 인증서 갱신 중..."
docker exec deploy-certbot certbot renew --quiet  # SSL 자동 갱신

echo "✅ 배포 완료!"

#!/bin/bash

echo "🚀 배포 시작: $(date)"

# 프로젝트 디렉토리 이동
cd /home/ubuntu/app/infra/deploy || exit

echo "🛑 기존 컨테이너 중지 중..."
docker-compose down  # 모든 기존 컨테이너 중지 및 제거

echo "🐳 최신 Docker 이미지 가져오는 중..."
docker-compose pull  # 최신 이미지 가져오기

echo "🔄 컨테이너 재시작 중..."
docker-compose up -d --force-recreate --remove-orphans  # 최신 이미지로 컨테이너 재시작

echo "🧹 사용하지 않는 Docker 이미지 정리"
docker image prune -f  # 불필요한 이미지 정리

echo "🔄 Nginx 설정 반영 중..."
# Nginx 컨테이너가 실행 중인지 확인하고 재시작
if [ "$(docker ps -q -f name=deploy-nginx)" ]; then
    echo "✅ Nginx 컨테이너 실행 중, 설정 반영 중..."
    docker exec deploy-nginx nginx -s reload  # 변경된 설정 반영
else
    echo "⚠️ Nginx 컨테이너가 실행 중이 아닙니다. 다시 시작합니다."
    docker-compose restart nginx
fi

echo "🔄 Certbot SSL 인증서 갱신 중..."
# Certbot 컨테이너가 실행 중인지 확인하고 갱신 실행
if [ "$(docker ps -q -f name=deploy-certbot)" ]; then
    echo "✅ Certbot 컨테이너 실행 중, SSL 인증서 갱신..."
    docker exec deploy-certbot certbot renew --quiet  # SSL 자동 갱신
else
    echo "⚠️ Certbot 컨테이너가 실행되지 않았습니다. 컨테이너를 재시작합니다."
    docker-compose restart certbot
fi

echo "✅ 배포 완료!"

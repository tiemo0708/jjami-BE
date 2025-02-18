#!/bin/bash

echo "🚀 배포 시작: $(date)"

# 프로젝트 디렉토리 이동
cd /home/ubuntu/app/infra/deploy || exit

echo "🛑 기존 컨테이너 중지 중..."
docker-compose down  # 기존 컨테이너 종료

echo "🐳 최신 Docker 이미지 가져오는 중..."
docker-compose pull  # 운영에서는 항상 최신 이미지 가져오기

echo "🔄 컨테이너 재시작 중..."
docker-compose up -d --force-recreate  # 최신 이미지로 컨테이너 재시작

echo "🧹 사용하지 않는 Docker 이미지 정리"
docker image prune -f  # 오래된 이미지 삭제하여 디스크 공간 확보

# 🔥 Nginx 설정 적용
echo "⚙️ Nginx 설정 적용 중..."
sudo cp /home/ubuntu/app/infra/deploy/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp /home/ubuntu/app/infra/deploy/nginx/default.conf /etc/nginx/conf.d/default.conf

# 🔍 Nginx 설정 테스트 및 적용
echo "🔍 Nginx 설정 테스트 중..."
sudo nginx -t
if [ $? -eq 0 ]; then
    echo "✅ Nginx 설정이 올바름. 재시작 진행..."
    sudo systemctl restart nginx
else
    echo "❌ Nginx 설정 오류 발생! 배포 중단."
    exit 1
fi

echo "✅ 배포 완료!"

#!/bin/bash

echo "🚀 애플리케이션 시작 중..."
cd /home/ubuntu/jjami-BE || exit
docker-compose up -d

echo "✅ 애플리케이션 실행 완료!"

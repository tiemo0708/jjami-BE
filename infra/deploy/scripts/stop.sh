#!/bin/bash

echo "🛑 애플리케이션 중지 중..."
cd /home/ubuntu/jjami-BE || exit
docker-compose down

echo "✅ 애플리케이션 중지 완료!"

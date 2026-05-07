FROM public.ecr.aws/docker/library/node:24.11.1-alpine as builder
# 스테이지 1 시작. 별칭은 builder
WORKDIR /app
COPY package*.json .
# 설치 패키지 목록만 복사
RUN npm install
# 패키지 설치
COPY . .
# 소스코드 복사
RUN npm run build
# nodejs 환경에서만 동작하던 파일들이
# nginx같은 웹서버에서도 동작하는 정적인파일로 추출
# ./dist 경로에 저장됨.

####### 여기까지가 stage 1 #########

FROM public.ecr.aws/nginx/nginx:alpine
COPY ./default.conf /etc/nginx/conf.d/default.conf
# nginx 리버스프록시 설정파일을 컨테이너 복사
COPY --from=builder /app/dist /usr/share/nginx/html
# stage1에서 빌드된 정적파일(dist폴더내용)을 nginx의 웹루트디렉토리에 복사

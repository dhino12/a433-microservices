# Dockerfile untuk shipping-service
FROM node:18-alpine as base
WORKDIR /src

# Salin file package.json dan package-lock.json terlebih dahulu agar npm install bisa berjalan

FROM base as production
COPY package*.json ./
ENV NODE_ENV=production
RUN npm ci
COPY ./*.js .
EXPOSE 3001
CMD ["npm", "start"]

FROM base as dev
COPY package*.json ./
RUN apk add --no-cache bash
RUN wget -O /bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x /bin/wait-for-it.sh

ENV NODE_ENV=development
RUN npm install
COPY ./*.js ./

EXPOSE 3001
CMD ["npm", "start"]

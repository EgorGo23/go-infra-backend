FROM node:18.15.0-alpine3.17 As development

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY ./ /app
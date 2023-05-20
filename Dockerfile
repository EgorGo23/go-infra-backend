FROM node:18.15.0-alpine3.17 As development

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY ./ /app

FROM node:18.15.0-alpine3.17 As build

WORKDIR /app

COPY package*.json ./

COPY --from=development /app/node_modules ./node_modules

COPY ./ /app

RUN npm run build

ENV NODE_ENV production

RUN npm ci --only=production && npm cache clean --force

FROM node:18.15.0-alpine3.17 As production

COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

CMD [ "node", "/dist/main.js" ]
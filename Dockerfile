FROM node:18.15.0-alpine3.17 As development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY . .

FROM node:18.15.0-alpine3.17 As build

WORKDIR /usr/src/app

COPY package*.json ./

COPY --from=development /usr/src/app/node_modules ./node_modules

COPY . .

RUN npm run build

ENV NODE_ENV production

RUN npm ci --only=production && npm cache clean --force

FROM node:18.15.0-alpine3.17 As production

COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

CMD [ "node", "/dist/main.js" ]
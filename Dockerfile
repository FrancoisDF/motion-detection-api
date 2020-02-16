FROM mhart/alpine-node:13


ARG NODE_ENV=prod
ENV NODE_ENV=$NODE_ENV

RUN npm install pm2 -g

WORKDIR /app
COPY ./yarn.lock ./
COPY ./package.json ./
RUN yarn install

COPY ./ .
RUN yarn build

EXPOSE 5000

CMD ["pm2-runtime", "pm2-process.json"]


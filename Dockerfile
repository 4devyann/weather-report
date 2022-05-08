ARG WORK_DIR=/weather_build

FROM node:14.18 as builder

ARG WORK_DIR
ENV PATH ${WORK_DIR}/node_modules/.bin:$PATH

RUN mkdir ${WORK_DIR}
WORKDIR ${WORK_DIR}

COPY package.json ${WORK_DIR}
COPY package-lock.json ${WORK_DIR}

RUN npm install @angular/cli
RUN npm install

COPY . ${WORK_DIR}

RUN ng build --configuration production

FROM nginx:latest

ARG WORK_DIR

COPY --from=builder ${WORK_DIR}/dist/weather-report /usr/share/nginx/html/weather

COPY ./nginx/nginx.conf /etc/nginx/conf.d/weather.conf

EXPOSE 4204

CMD nginx -g "daemon off;"
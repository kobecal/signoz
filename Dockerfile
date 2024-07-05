FROM us.gcr.io/aftership-admin/jenkins/nodejs-base:nodejs-18.12.1 as builder

RUN  apt-get -y install make
COPY . .

RUN make build-frontend-static


FROM nginx:1.26-alpine

# Add Maintainer Info
LABEL maintainer="signoz"

# Set working directory
WORKDIR /frontend

# Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx config and static files
COPY --from=0  conf/default.conf /etc/nginx/conf.d/default.conf
COPY --from=0   build /usr/share/nginx/html

EXPOSE 3301

ENTRYPOINT ["nginx", "-g", "daemon off;"]


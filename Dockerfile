# use a minimal alpine image
# use a minimal alpine image
FROM us.gcr.io/aftership-admin/jenkins/golang-base:golang-1.22.1

WORKDIR /deploy/signoz
COPY go.mod go.sum ./
RUN  go mod download
COPY . .
RUN  make QUERY_SERVICE_DIRECTORY='ee/query-service'  build-query-service-static-amd64

USER root
WORKDIR /root
# copy the query-service binary
RUN cp   /deploy/signoz/ee/query-service/bin/query-service-linux-amd64 /root/query-service
# copy prometheus YAML config
RUN mkdir /root/config/
RUN cp   /deploy/signoz/pkg/query-service/config/prometheus.yml   /root/config/prometheus.yml
RUN cp -r  /deploy/signoz/pkg/query-service/templates   /root/templates





# Make query-service executable for non-root users
RUN chmod 755 /root /root/query-service
#
## run the binary
ENTRYPOINT ["./query-service"]
#CMD ["-config", "${WORK_DIR}/config/prometheus.yml"]
EXPOSE 8080

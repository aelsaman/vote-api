# FROM image-registry.openshift-image-registry.svc:5000/openshift/golang:latest as builder
FROM registry.access.redhat.com/ubi8/go-toolset:1.14.12 as builder
# FROM docker.io/library/golang:latest as builder

WORKDIR /build
ADD . /build/

RUN export GARCH="$(uname -m)" && if [[ ${GARCH} == "x86_64" ]]; then export GARCH="amd64"; fi && GOOS=linux GOARCH=${GARCH} CGO_ENABLED=0 go build -mod=vendor -o api-server .
# RUN go build -mod=vendor -o api-server .

FROM scratch

WORKDIR /app
COPY --from=builder /build/api-server /app/api-server

CMD [ "/app/api-server" ]

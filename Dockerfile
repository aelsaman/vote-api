# FROM image-registry.openshift-image-registry.svc:5000/openshift/golang:latest as builder
# FROM registry.redhat.io/openshift/golang:latest as builder
FROM docker.io/library/golang:latest as builder

WORKDIR /build
ADD . /build/

RUN go build -mod=vendor -o api-server .

FROM scratch

WORKDIR /app
COPY --from=builder /build/api-server /app/api-server

CMD [ "/app/api-server" ]

# Copied from https://github.com/prometheus/client_golang/blob/master/examples/simple/Dockerfile

FROM resin/raspberry-pi-golang-alpine:1.9.2 AS builder

RUN [ "cross-build-start" ]
WORKDIR /go/src/github.com/infrastructure-as-code/docker-hello-world
ENV GIN_MODE debug
ENV DEBIAN_FRONTEND noninteractive
COPY Makefile *.go ./
RUN apk update && \
	apk upgrade && \
	apk add \
		git \
		make && \
	make all
RUN [ "cross-build-end" ] 

FROM scratch
LABEL maintainer "Vince Tse <thelazyenginerd@gmail.com>"
COPY --from=builder /go/src/github.com/infrastructure-as-code/docker-hello-world/hello_world .
ENV GIN_MODE release
EXPOSE 8080
ENTRYPOINT ["/hello_world"]

FROM golang:1.17-alpine

ARG version="v0.3.0"

COPY scan.sh /bin/scan

RUN \
	CGO_ENABLED=0 go install github.com/praetorian-inc/gokart@${version} && \
	chmod +x /bin/scan

ENTRYPOINT ["/bin/scan"]

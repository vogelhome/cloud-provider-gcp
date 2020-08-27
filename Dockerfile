############# builder            #############
FROM golang:1.15.0 AS builder

WORKDIR /go/src/github.com/gardener/cloud-provider-gcp
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install \
  -mod=vendor \
  ./...

############# base               #############
FROM alpine:3.12.0 AS base

RUN apk add --update bash curl

WORKDIR /

############# cloud-provider-gcp #############
FROM base AS cloud-provider-gcp

COPY --from=builder /go/bin/gcp-cloud-controller-manager /gcp-cloud-controller-manager

ENTRYPOINT ["/gcp-cloud-controller-manager"]

FROM cgr.dev/chainguard/go@sha256:97cdcb13907ad7170f01b1ece2bdde1a0132096f695b0cc7123d2749df74f7cf AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:0ff0755007e9f495d27af37bd8defff5856875fa65ed9b60a77388b332bdc773

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/docs docs

ENV ARANGO_HOST localhost
ENV ARANGO_USER root
ENV ARANGO_PASS rootpassword
ENV ARANGO_PORT 8529
ENV MS_PORT 8080

EXPOSE 8080

ENTRYPOINT [ "/app/main" ]

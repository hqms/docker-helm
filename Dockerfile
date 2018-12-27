FROM alpine:3.8 as build
LABEL maintainer="HQM <hakim.arif.harier@gmail.com>"

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.12.1
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=891004bec55431b39515e2cedc4f4a06e93782aa03a4904f2bd742b168160451

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.8

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

CMD ["/bin/helm"]

#!/bin/sh
set -x
set -e

# Set temp environment vars
export GOPATH=/tmp/go
export PATH=${PATH}:${GOPATH}/bin
export GO15VENDOREXPERIMENT=1

#echo "http://dl-3.alpinelinux.org/alpine/edge/community/" > /etc/apk/repositories
#echo "https://pkgs.alpinelinux.org/package/edge/community" > /etc/apk/repositories
#apk update
# Install build deps
apk --no-cache --no-progress add --virtual build-deps build-base linux-pam-dev go
apk add --no-cache gogs --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted

# Install glide
git clone -b 0.10.2 https://github.com/Masterminds/glide ${GOPATH}/src/github.com/Masterminds/glide
cd ${GOPATH}/src/github.com/Masterminds/glide
make build
go install

# Build Gogs
#mkdir -p ${GOPATH}/src/github.com/gogits/
#ln -s /app/gogs/ ${GOPATH}/src/github.com/gogits/gogs
#cd ${GOPATH}/src/github.com/gogits/gogs
#glide get github.com/go-xorm/builder
#glide update
#glide install
#glide get github.com/go-xorm/builder
#go get github.com/bradfitz/gomemcache/memcache
#go get github.com/go-macaron/inject
#go get github.com/go-xorm/builder
#go get github.com/jaytaylor/html2text
#go get github.com/klauspost/compress/gzip
#go get github.com/shurcooL/sanitized_anchor_name
#go get gopkg.in/asn1-ber.v1
#go get gopkg.in/redis.v2
#make build TAGS="sqlite cert pam"

# Cleanup GOPATH & vendoring dir
#rm -r $GOPATH /app/gogs/vendor

# Remove build deps
apk --no-progress del build-deps

# Create git user for Gogs
adduser -H -D -g 'Gogs Git User' git -h /data/git -s /bin/bash && passwd -u git
echo "export GOGS_CUSTOM=${GOGS_CUSTOM}" >> /etc/profile

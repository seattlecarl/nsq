#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
version=$(awk '/const Binary/ {print $NF}' < $DIR/internal/version/binary.go | sed 's/"//g')
goversion=$(go version | awk '{print $3}')


#echo "... running tests"
#./test.sh
#
#for os in linux darwin freebsd windows; do
#    echo "... building v$version for $os/$arch"
#    BUILD=$(mktemp -d ${TMPDIR:-/tmp}/nsq-XXXXX)
#    TARGET="nsq-$version.$os-$arch.$goversion"
#    GO111MODULE=on GOOS=$os GOARCH=$arch CGO_ENABLED=0 \
#        make DESTDIR=$BUILD PREFIX=/$TARGET BLDFLAGS="$GOFLAGS" install
#    pushd $BUILD
#    sudo chown -R 0:0 $TARGET
#    tar czvf $TARGET.tar.gz $TARGET
#    mv $TARGET.tar.gz $DIR/dist
#    popd
#    make clean
#    sudo rm -r $BUILD
#done

docker build -f DockerfileDebug -t nsqio/nsq:v$version-local .
if [[ ! $version == *"-"* ]]; then
    echo "Tagging nsqio/nsq:v$version as the latest release."
    docker tag nsqio/nsq:v$version-local nsqio/nsq:latest-local
fi

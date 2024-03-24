#!/bin/bash -eux

set -euxo pipefail

source /etc/lsb-release
CMAKE_PKG='cmake'
DIST_SUITE="llvm-toolchain-$DISTRIB_CODENAME-$LLVM_VERSION"
if [[ "$DISTRIB_CODENAME" == "focal" ]]; then
    wget https://apt.llvm.org/llvm-snapshot.gpg.key -qO /etc/apt/trusted.gpg.d/llvm.asc
    echo "deb https://apt.llvm.org/$DISTRIB_CODENAME/ ${DIST_SUITE} main" > /etc/apt/sources.list.d/llvm.list
    # use backported cmake package
    CMAKE_PKG='cmake-mozilla'
else
    sed -e "s|@DISTRO_SERIES@|${DISTRIB_CODENAME}|g" \
        -e "s|@DISTRO_SERIES_LLVM_VERSION@|${DIST_SUITE}|g" \
        /tmp/apt-llvm-org.sources.in > /etc/apt/sources.list.d/apt-llvm-org.sources
fi
apt-get update
apt-get install -y "clang-$LLVM_VERSION" "lld-$LLVM_VERSION" "${CMAKE_PKG}"
if [[ "$LLVM_VERSION" -ge 13 ]]; then
    apt-get install -y "libmlir-$LLVM_VERSION-dev"
fi
apt-get clean

ln -sf ld.lld-"$LLVM_VERSION" /usr/bin/ld && ld --version

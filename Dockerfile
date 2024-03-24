ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}
ARG LLVM_VERSION=11
ENV DEBIAN_FRONTEND=noninteractive
ENV LLVM_VERSION=${LLVM_VERSION}
# base dependencies
RUN apt-get update && \
    apt-get install -y wget git bash xz-utils build-essential python3-pip pkg-config ninja-build gdb ccache && \
    apt-get clean
RUN pip3 install -U setuptools wheel lit
COPY --chown=root:root apt-llvm-org.sources.in /tmp/apt-llvm-org.sources.in
COPY setup.sh /tmp/setup.sh
RUN bash /tmp/setup.sh && rm -f /tmp/setup.sh /tmp/apt-llvm-org.sources.in
# set default C/C++ compiler
ENV CC=clang-${LLVM_VERSION}
ENV CXX=clang++-${LLVM_VERSION}

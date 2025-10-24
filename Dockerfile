FROM ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        curl \
        build-essential \
        libpam0g-dev \
        ca-certificates \
        xz-utils \
        && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://ziglang.org/download/0.14.1/zig-x86_64-linux-0.14.1.tar.xz && \
    tar -xf zig-x86_64-linux-0.14.1.tar.xz && \
    mv zig-x86_64-linux-0.14.1 /opt/zig && \
    ln -s /opt/zig/zig /usr/local/bin/zig && \
    rm zig-x86_64-linux-0.14.1.tar.xz && \
    zig version && \
    mkdir /src

COPY . /src

WORKDIR /src

RUN zig build

FROM scratch
COPY --from=build /src/zig-out/lib/ /

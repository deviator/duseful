FROM debian:stretch-slim
RUN apt-get update && apt-get install -y \
    make cmake bash p7zip-full zlib1g-dev libssl-dev tar wget gpg xz-utils \
    gcc-arm-linux-gnueabihf ca-certificates \
    && apt-get autoremove -y && apt-get clean

ARG ldcver=1.11.0

RUN wget -O /root/ldc.tar.xz https://github.com/ldc-developers/ldc/releases/download/v$ldcver/ldc2-$ldcver-linux-x86_64.tar.xz \
    && tar xf /root/ldc.tar.xz -C /root/ && rm /root/ldc.tar.xz
ENV PATH "/root/ldc2-$ldcver-linux-x86_64/bin:$PATH"
ADD entry.sh /entry.sh
RUN chmod +x /entry.sh
WORKDIR /workdir
ENTRYPOINT [ "/entry.sh" ]
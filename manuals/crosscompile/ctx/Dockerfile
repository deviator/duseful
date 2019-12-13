FROM debian:buster-slim

RUN apt-get update && apt-get install -y \
    make cmake bash p7zip-full tar wget curl gpg xz-utils \
    zlib1g-dev libssl-dev sassc unzip npm \
    gcc-arm-linux-gnueabihf ca-certificates \
    && apt-get autoremove -y && apt-get clean

ARG ldcver=1.18.0
ARG ldcgiturl=https://github.com/ldc-developers/ldc/releases/download/v$ldcver

RUN mkdir /d
RUN    wget -O /d/ldc.tar.xz ${ldcgiturl}/ldc2-${ldcver}-linux-x86_64.tar.xz \
    && wget -O /d/ldc-win.7z ${ldcgiturl}/ldc2-${ldcver}-windows-multilib.7z \
    && wget -O /d/ldcsrc.zip ${ldcgiturl}/ldc-${ldcver}-src.zip \
    && tar xf /d/ldc.tar.xz -C /d/ \
    && unzip -d /d /d/ldcsrc.zip \
    && mv /d/ldc2-${ldcver}-linux-x86_64 /d/ldc2 \
    && mv /d/ldc-${ldcver}-src /d/ldc-src \
    && rm /d/ldc.tar.xz \
    && rm /d/ldcsrc.zip

RUN 7za x -o/d /d/ldc-win.7z \
    && mv /d/ldc2-${ldcver}-windows-multilib/lib32 /d/ldc2/win-lib32 \
    && mv /d/ldc2-${ldcver}-windows-multilib/lib64 /d/ldc2/win-lib64 \
    && rm -rf /d/ldc2-${ldcver}-windows-multilib \
    && rm /d/ldc-win.7z

ENV PATH "/d/ldc2/bin:$PATH"

RUN CC=arm-linux-gnueabihf-gcc ldc-build-runtime -j4 \
    --dFlags="-mtriple=armv7l-linux-gnueabihf" \
    --ldcSrcDir=/d/ldc-src/ \
    --buildDir=/tmp/arm-rt --targetSystem="Linux;UNIX" \
    && mv /tmp/arm-rt/lib /d/ldc2/arm-lib \
    && rm -rf /tmp/arm-rt

ADD ldc2.conf /d/ldc2/etc/ldc2.conf

WORKDIR /workdir
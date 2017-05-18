FROM debian:stretch-slim
MAINTAINER Eric Anholt <eric@anholt.net>

RUN apt-get update -qq && apt-get install --no-install-recommends -qq -y \
        clang \
        gcc \
        locales \
        libc6-dev \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        libgles1-mesa-dev \
        libgles2-mesa-dev \
        libgl1-mesa-dri \
        ninja-build \
        pkg-config \
        python3 \
        python3-pip \
        python3-setuptools

RUN rm -rf /usr/share/doc/* /usr/share/man/*

RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

RUN pip3 install meson

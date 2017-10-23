FROM debian:stretch-slim
MAINTAINER Eric Anholt <eric@anholt.net>

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -qq -y \
        autoconf \
        automake \
        ccache \
        clang \
        gcc \
        git \
        libc6-dev \
        libgbm-dev \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        libgles1-mesa-dev \
        libgles2-mesa-dev \
        libgl1-mesa-dri \
        libdbus-1-dev \
        libdmx-dev \
        libdrm-dev \
        libudev-dev \
        libexpat1-dev \
        libepoxy-dev \
        libfontenc-dev \
        libpciaccess-dev \
        libpixman-1-dev \
        libpng-dev \
        libselinux1-dev \
        libtool \
        libunwind8-dev \
        libxau-dev \
        libxaw7-dev \
        libxcb1-dev \
        libxcb-image0-dev \
        libxcb-render-util0-dev \
        libxcb-util0-dev \
        libxdmcp-dev \
        libxext-dev \
        libxfont-dev \
        libxfixes-dev \
        libxi-dev \
        libxkbfile-dev \
        libxmu-dev \
        libxrender-dev \
        libxshmfence-dev \
        libxt-dev \
        libxtst-dev \
        libunwind8-dev \
        locales \
        make \
        nettle-dev \
        ninja-build \
        perl \
        pkg-config \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        x11proto-bigreqs-dev \
        x11proto-composite-dev \
        x11proto-core-dev \
        x11proto-damage-dev \
        x11proto-dri2-dev \
        x11proto-dri3-dev \
        x11proto-dmx-dev \
        x11proto-gl-dev \
        x11proto-fixes-dev \
        x11proto-fonts-dev \
        x11proto-input-dev \
        x11proto-present-dev \
        x11proto-randr-dev \
        x11proto-record-dev \
        x11proto-render-dev \
        x11proto-resource-dev \
        x11proto-scrnsaver-dev \
        x11proto-video-dev \
        x11proto-xcmisc-dev \
        x11proto-xf86bigfont-dev \
        x11proto-xf86dga-dev \
        x11proto-xf86dri-dev \
        x11proto-xf86vidmode-dev \
        x11proto-xinerama-dev \
        x11-xkb-utils \
        x11-utils \
        x11-xserver-utils \
        xcb-proto \
        xfonts-utils \
        xkb-data \
   && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/share/doc/* /usr/share/man/*

RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

RUN pip3 install meson==0.43.0

RUN mkdir -p /root
WORKDIR /root
RUN git clone --depth 1 git://anongit.freedesktop.org/git/xorg/util/modular

ENV PREFIX=/usr

# Install the autoconf macros for xts
RUN git clone --depth 1 git://anongit.freedesktop.org/git/xorg/util/macros && cd macros && ./autogen.sh --prefix=$PREFIX && make install && cd .. && rm -rf macros

# Install current rendercheck
RUN git clone --depth 1 git://anongit.freedesktop.org/git/xorg/app/rendercheck && cd rendercheck && meson build/ --prefix=$PREFIX && ninja -C build/ install && cd .. && rm -rf rendercheck

# Build the X Test suite.  Don't install it, but nuke some of the
# build files to reduce image size.
RUN git clone --depth 1 git://anongit.freedesktop.org/git/xorg/test/xts && cd xts && ./autogen.sh && make && find . -name ".libs/*.o" | xargs rm -f

# Clone the piglit test harness.  We'll use this for executing the
# xts tests.
RUN git clone --depth 1 git://anongit.freedesktop.org/git/piglit

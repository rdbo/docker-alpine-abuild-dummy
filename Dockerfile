FROM alpine:edge

# Setup packages
RUN printf "http://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing\n" > /etc/apk/repositories
RUN apk update
RUN apk add alpine-sdk git doas
RUN apk add gcc g++ cmake samurai meson # Common dependencies for C/C++ packages
RUN apk add cargo cargo-auditable # Common dependencies for Rust packages
RUN apk add python3-dev py3-gpep517 py3-setuptools py3-wheel py3-pytest py3-installer # Common dependencies for Python packages
RUN apk add expat-dev freetype fontconfig-dev libxau-dev xorgproto libmd libbsd libxdmcp-dev libxcb-dev ncurses wlroots-dev # X11/Wayland/font/etc

# Create local package repository
RUN mkdir /repo
RUN mkdir /repo/main /repo/community /repo/testing
RUN chown -R root:abuild /repo
RUN chmod 775 /repo

# Create helper script for building packages
RUN printf "#!/bin/sh\nabuild -rf -kK -P /repo" > /usr/local/bin/buildapk
RUN chmod 755 /usr/local/bin/buildapk

# Setup build user
RUN adduser -D build -G abuild
RUN addgroup build wheel
RUN echo "permit nopass keepenv :wheel" > /etc/doas.conf
USER build
RUN abuild-keygen -i -a -n

# Setup aports directory
USER root
RUN mkdir -p /aports
RUN chown build:abuild /aports

USER build

# NOTE: Pass the aports directory on the host machine using `-v <host dir:/aports`
WORKDIR /aports

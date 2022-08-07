FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG FLAGS=-DAPP_RENDER_SYSTEM=gl
ENV KODI_CMD=kodi-standalone
ENV KODI_GBM_OPTS=auto

RUN apt-get update                                                                                                                    && \
    apt-get install -y --no-install-recommends python3-pycryptodome git software-properties-common default-jdk tzdata ca-certificates && \
    apt-get install -y --no-install-recommends intel-media-va-driver-non-free mesa-va-drivers meson libpciaccess-dev                  && \
    add-apt-repository -s ppa:team-xbmc/xbmc-nightly                                                                                  && \
    apt-get update                                                                                                                    && \
    apt-get install -y --no-install-recommends libnss3 kodi-eventclients-kodi-send retroarch libretro-*                               && \
    apt-get install -y --no-install-recommends libgbm-dev libinput-dev libxkbcommon-dev && \
    apt-get build-dep -y kodi                                                                                                         && \
    apt-get -y purge software-properties-common                                                                                       && \
    rm -rf /var/lib/apt/lists/*                                                                                                       && \
    git clone -b master https://github.com/xbmc/xbmc /usr/src/kodi                                                                    && \
    git clone git://anongit.freedesktop.org/mesa/drm /usr/src/drm                                                                     && \
    git clone https://github.com/xbmc/platform.git /usr/src/platform                                                                  && \
    git clone https://github.com/xbmc/kodi-platform.git /usr/src/kodi-platform                                                        && \
    git clone -b Nexus https://github.com/kodi-game/game.libretro /usr/src/game.libretro                                             && \
    git clone -b master https://github.com/kodi-game/game.libretro.snes9x /usr/src/game.libretro.snes9x                               && \
    git clone -b master https://github.com/kodi-game/game.libretro.beetle-psx /usr/src/game.libretro.beetle-psx                       && \
    mkdir /usr/src/kodi-build                                                                                                         && \
    mkdir /usr/src/drm-build                                                                                                          && \
    cd /usr/src/drm                                                                                                                   && \
    meson /usr/src/drm-build                                                                                                          && \
    ninja -C /usr/src/drm-build all                                                                                                   && \
    cp /usr/src/drm-build/tests/modetest/modetest /usr/local/bin/                                                                     && \
    cd /usr/src/kodi-build                                                                                                            && \
    cmake /usr/src/kodi -DCMAKE_INSTALL_PREFIX=/usr/local $FLAGS                                                                      && \
    cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)                                                                       && \
    make install                                                                                                                      && \
    cd /usr/src/kodi                                                                                                                  && \
    make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons PREFIX=/usr/local                                       && \
    cd /usr/src/platform/                                                                                                             && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local                                                                                         && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install                                                                               && \
    cd /usr/src/kodi-platform/                                                                                                        && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local                                                                                         && \
    make -j$(getconf _NPROCESSORS_ONLN)  && make install                                                                              && \
    cd /usr/src/game.libretro/                                                                                                        && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local                                                                                         && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install                                                                               && \
    cd /usr/src/game.libretro.snes9x/                                                                                                 && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local                                                                                         && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install                                                                               && \
    cd /usr/src/game.libretro.beetle-psx/                                                                                             && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local                                                                                         && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install                                                                               && \
    rm -rf /usr/src/*                                                                                                                 && \
    apt-get remove --purge -y libstdc++-9-dev:amd64 libstdc++-10-dev:amd64 libgcc-10-dev:amd64 libgphobos-10-dev:amd64 libgcc-9-dev:amd64 gcc-9 gdc-10 gcc-10 cpp-9 cpp-10 default-jdk autoconf meson libpciaccess-dev automake autopoint cmake default-jre gawk gcc g++ cpp ninja-build waylandpp-dev && \
    apt-get -y --purge autoremove

COPY entrypoint.sh /
COPY gbm-set-color-range.sh /
ENTRYPOINT ["/entrypoint.sh"]

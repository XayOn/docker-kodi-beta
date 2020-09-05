FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG FLAGS=-DX11_RENDER_SYSTEM=gl                                

RUN apt-get update                                                                                                                    && \
    apt-get install -y --no-install-recommends python-pycryptodome git software-properties-common default-jdk tzdata ca-certificates  && \
    add-apt-repository -s ppa:team-xbmc/xbmc-nightly                                                                                  && \
    apt-get update                                                                                                                    && \
    apt-get install -y --no-install-recommends libnss3 kodi-eventclients-kodi-send retroarch libretro-*                               && \
    apt-get build-dep -y kodi                                                                                                         && \
    apt-get -y purge software-properties-common                                                                                       && \
    rm -rf /var/lib/apt/lists/*                                                                                                       && \
    git clone -b master https://github.com/xbmc/xbmc /usr/src/kodi                                                                    && \
    git clone https://github.com/xbmc/platform.git /usr/src/platform                                                                  && \
    git clone https://github.com/xbmc/kodi-platform.git /usr/src/kodi-platform                                                        && \
    git clone -b Matrix https://github.com/kodi-game/game.libretro /usr/src/game.libretro                                             && \
    git clone -b master https://github.com/kodi-game/game.libretro.snes9x /usr/src/game.libretro.snes9x                               && \
    git clone -b master https://github.com/kodi-game/game.libretro.beetle-psx /usr/src/game.libretro.beetle-psx                       && \
    mkdir /usr/src/kodi-build                                                                                                         && \
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
    apt-get remove --purge -y libstdc++-9-dev:amd64 libstdc++-10-dev:amd64 libgcc-10-dev:amd64 libgphobos-10-dev:amd64 libgcc-9-dev:amd64 gcc-9 gdc-10 gcc-10 cpp-9 cpp-10 default-jdk autoconf automake autopoint cmake default-jre gawk gcc g++ cpp ninja-build waylandpp-dev && \
    apt-get -y --purge autoremove                                                                                                     && \
    rm /usr/lib/*/*.a

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

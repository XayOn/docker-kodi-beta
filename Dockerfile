FROM ubuntu:latest

# Install nightlies ppa and build-deps
RUN apt-get update                                                        && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -s ppa:team-xbmc/xbmc-nightly                      && \
    apt-get update                                                        && \
    apt-get install -y --no-install-recommends git retroarch libretro-* default-jdk tzdata ca-certificates && \
    apt-get build-dep -y kodi                                             && \
    apt-get -y purge software-properties-common                           && \
    rm -rf /var/lib/apt/lists

# This takes fewer steps, but is able to remove most of the produced image size (/usr/src)
RUN git clone -b master https://github.com/xbmc/xbmc /usr/src/kodi                && \
    mkdir /usr/src/kodi-build                                                     && \
    cd /usr/src/kodi-build                                                        && \
    cmake /usr/src/kodi -DCMAKE_INSTALL_PREFIX=/usr/local -DX11_RENDER_SYSTEM=gl  && \
    cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)                   && \
    make install                                                                  && \
    cd /usr/src/kodi                                                              && \
    make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons PREFIX=/usr/local && \
    git clone https://github.com/xbmc/platform.git /usr/src/platform && \
    cd /usr/src/platform/                                            && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local                          && \
    make && make install && 
    git clone https://github.com/xbmc/kodi-platform.git /usr/src/kodi-platform && \
    cd /usr/src/kodi-platform/                                                 && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                    && \
    make && make install && \
    git clone -b Matrix https://github.com/kodi-game/game.libretro /usr/src/game.libretro && \
    cd /usr/src/game.libretro/                                                            && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                               && \
    make && make install && \
    git clone -b master https://github.com/kodi-game/game.libretro.snes9x /usr/src/game.libretro.snes9x && \
    cd /usr/src/game.libretro.snes9x/                                                     && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                               && \
    make && make install  && \
    git clone -b master https://github.com/kodi-game/game.libretro.beetle-psx /usr/src/game.libretro.beetle-psx && \
    cd /usr/src/game.libretro.beetle-psx/                                                 && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                               && \
    make && make install && \
    rm -rf /usr/src/*

# TODO: Currently not working

# # Build libretro plugin for gb
# RUN cd /usr/src && git clone -b master https://github.com/kodi-game/game.libretro.sameboy /usr/src/game.libretro.sameboy && \
#     cd /usr/src/game.libretro.sameboy/                                                    && \
#     cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                               && \
#     make && make install

# Build libretro plugin for gba
# RUN cd /usr/src && git clone -b master https://github.com/kodi-game/game.libretro.beetle-gba /usr/src/game.libretro.beetle-gba && \
#     cd /usr/src/game.libretro.beetle-gba/                                                 && \
#     cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                               && \
#     make && make install

# Build libretro plugin for gba
# RUN cd /usr/src && git clone -b master https://github.com/kodi-game/game.libretro.mame2003 /usr/src/game.libretro.mame2003 && \
#     cd /usr/src/game.libretro.mame2003/                                                   && \
#     cmake -DCMAKE_INSTALL_PREFIX=/usr/local                                               && \
#     make && make install

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

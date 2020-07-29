<span style="display:block;text-align:center">[![](https://raw.githubusercontent.com/XayOn/docker-kodi-beta/master/kodilovesdocker.png)](https://hub.docker.com/r/xayon/docker-kodi-beta) </span>

<center><h1> Dockerized KODI matrix (v19) </h1> </center>

<span style="display:block;text-align:center">![](https://github.com/XayOn/docker-kodi-beta/workflows/Publish%20to%20Docker/badge.svg) ![](https://img.shields.io/docker/pulls/xayon/docker-kodi-beta)</span>


Use Kodi matrix without any sweat. Made with :heartpulse: by David Francos.
Dockerized kodi master branch, fresh and nice!

> :warning: **This is the UNSTABLE version of KODI**

:computer: This repository contains a single Dockerfile implementing the [oficially recommended way][5] of KODI build on linux. It comes with Github Actions integration for automatic builds, for the current git on the KODI repository reference linked in this readme (Currently [25af3208][4]).


# What will you get

- Up to date bleeding edge kodi Docker image
- Complete set of KODI binary addons (pvr, visual representations)
- Libretro binary addons with multiple emulators (psx, snes...)

# Installation

**This image will work on any x64 system where you can run docker**.

For simplicity, *x11docker* is recommended, wich will limit your options to any
system with linux and bash.

> :warning: ** ARM is not supported **

First install **x11docker** following its installation [guide][3].
Then, launch **xayon/docker-kodi-beta** with x11docker, the full extent of x11docker options is not to be part of this guide, you can refer to its documentation if you need advanced options.

For Xorg, with pulseaudio, you could launch it with the following command:

```bash
x11docker --xorg --pulseaudio --gpu --homedir $HOME/.kodi_matrix/ kodi_matrix
```


## Why

Kodi 19 isn't stable enough to be properly packaged with libretro and all the
binary add-ons.

At first (July 2020) the packages were broken, and, after a first manual build,
I decided this had to be automated. Docker seems like the best option for that.

Note that some addons are not yet migrated to python3, wich is a requirement
for kodi 19. 

I have successfully tested this build with:

- Jellyfin addon
- Netflix addon
- Youtube addon
- RomCollectionBrowser addon


## Acknowledgments

- SicLuceatLux for his [docker-kodi][1] wich introduced me to
  [x11docker][2] and inspired part of this Readme

[1]: https://github.com/SicLuceatLux/docker-kodi
[2]: https://github.com/mviereck/x11docker
[3]: https://github.com/mviereck/x11docker#shortest-way-for-first-installation "guide"
[4]: https://github.com/xbmc/xbmc/commit/25af32080990fda575d9d2ef7c7d8042b5730e25 "25af3208"
[5]: https://github.com/xbmc/xbmc/blob/master/docs/README.Linux.md "oficially recommended way"

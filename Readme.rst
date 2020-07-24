Dockerized KODI matrix (v19)
----------------------------

:sweat_drops: Test Kodi matrix without any sweat. Made with :heartpulse: by David Francos.

Launch the bleeding edge (unstable) latest kodi releases directly from kodi
master branch.

What will you get
-----------------

- Up to date bleeding edge (unstable!) kodi installation Docker image
- Complete set of KODI binary addons (pvr...)
- Libretro binary addons built-in

Installation
------------

This image will work on any x64 system where you can run docker.

For simplicity, x11docker is recommended, wich will limit your options to any
system with linux and bash.

.. note::
   ARM is not supported


Why
---

Kodi 19 isn't stable enough to be properly packaged with libretro and all the
binary add-ons.

At first (July 2020) the packages were broken, and, after a first manual build,
I decided this had to be automated. Docker seems like the best option for that.

Note that some addons are not yet migrated to python3, wich is a requirement
for kodi 19. 

I've tested this build with:

- Jellyfin addon
- Netflix addon
- Youtube addon
- RomCollectionBrowser addon


Acknowledgments
---------------

- SicLuceatLux for his `docker-kodi
  <https://github.com/SicLuceatLux/docker-kodi`_ wich introduced me to
  x11docker and inspired part of this Readme

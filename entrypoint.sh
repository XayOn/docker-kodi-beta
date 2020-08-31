#!/bin/bash

stop_or_kill() {
  kodi-send --action="Quit" && sleep 10
  [[ -z $(pidof kodi.bin) ]] || kill -9 kodi.bin
}

init() {
  command="${KODI_CMD:-kodi-standalone}"
  trap stop_or_kill EXIT
  $command
}

init

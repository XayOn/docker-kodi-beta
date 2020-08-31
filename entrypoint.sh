#!/bin/bash

stop_or_kill() {
  kodi-send --action="Quit" && sleep 10
  [[ -z $(get_kodi_pid) ]] || kill -9
}

init() {
  command="${KODI_CMD:-kodi-standalone}"
  trap stop_or_kill EXIT
  $command
}

init

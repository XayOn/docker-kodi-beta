#/bin/bash
###
# gbm-set-color-range.sh
#
# sets connected display output device to specified color range
# must by run before starting kodi
#
# wsnipex    29.07.2018
###

OPTS="$1"
case "$OPTS" in
  auto)
    MODE=0
    ;;
  full)
    MODE=1
    ;;
  limited)
    MODE=2
    ;;
  *)
    echo "usage $0 full|limited|auto"
    exit 2
    ;;
esac

while read -r CONNECTOR OUTPUT; do
  echo "setting $OUTPUT to $MODE"
  if [ -n "$CONNECTOR" ]; then
    modetest -w $CONNECTOR:"Broadcast RGB":$MODE || exit $?
  else
    echo "connector not found"
    exit 1
  fi
done <<< $(modetest -c | awk '/\tconnected/ {print $1, $4}')

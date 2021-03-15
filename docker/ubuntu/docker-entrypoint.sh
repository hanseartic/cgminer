#!/bin/bash
set -e

if [ $# == 0 ]; then
  echo "$0: used default.conf for cgminer"
  set -- cgminer --config /etc/config/cgminer.conf
fi

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for cgminer"
  set -- cgminer "$@"
fi

if [ "$1" = "cgminer" ]; then
  /lib/systemd/system-udevd -d
  udevadm control --reload-rules && udevadm trigger -c add
  kill -9 $(pidof system-udevd)
  echo "run : $@ "
  exec gosu nobody "$@"
fi

echo "run some: $@"
exec "$@"


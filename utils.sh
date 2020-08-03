#!/bin/sh

set -e

yellow() {
  msg="$@"
  if [ -t 1 ]; then
    printf "\033[1;33;49m%s\033[m\n" "$msg"
  else
    echo "$msg"
  fi
}

say() {
  msg="$@"
  if [ -t 1 ]; then
    printf "\033[1;34;49m%s\033[m\n" "$msg"
  else
    echo "$msg"
  fi
}

complain() {
  msg="$@"
  if [ -t 1 ]; then
    printf "\033[1;31;49m%s\033[m\n" "$msg"
  else
    echo "$msg"
  fi
}

run() {
  say "\$ $@"
  local rc=0
  "$@" || rc=$?
  if [ $rc -ne 0 ]; then
    complain "[E]: The command \"$@\" failed with status code $rc, terminating..."
    yellow "[I]: Is your graphic card enabled? If you are on optimus system remember to activate the graphics using: optirun ./run [command]"
    complain "[E]: If you have no idea of what went wrong, please feel free to ask for help in interscity.org"
    exit 1
  fi
}


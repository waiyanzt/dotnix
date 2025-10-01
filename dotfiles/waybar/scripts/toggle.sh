#!/bin/sh

if pgrep -f "$1" > /dev/null; then
    pkill -f "$1"
else
    $1 &
fi

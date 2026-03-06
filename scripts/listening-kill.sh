#!/bin/bash

if [ $# -eq 1 ]; then
    sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    lsof -ti tcp:$1 | xargs kill -9
else
    echo "Usage: listening-kill [pattern]"
fi

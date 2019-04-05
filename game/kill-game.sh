#!/bin/bash

if [[ -f 'Baba Is You.exe' ]]; then
    PROCESS_NAME="Baba Is You"
    kill -9 $(ps aux | grep "$PROCESS_NAME" | grep -v grep  | awk '{print $1}')
else
    PROCESS_NAME="Chowdren"
    kill -9 $(ps aux | grep "$PROCESS_NAME" | grep -v grep | awk '{print $2}')
fi


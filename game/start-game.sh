#!/bin/bash

if [[ -f 'Baba Is You.exe' ]]; then
    EXECUTABLE="./Baba\ Is\ You.exe"
else
    EXECUTABLE="./run.sh"
fi

eval $EXECUTABLE 2>&1 | sed --unbuffered 's/#~\t\(.*\)/\1/;t;d' | tee log.log

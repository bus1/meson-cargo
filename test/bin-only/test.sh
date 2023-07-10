#!/bin/bash

if [[ -n "${1}" ]] ; then
        R=0
        "${1}" || R=$?
        [[ "$R" == "71" ]] && exit 0
fi

exit 1

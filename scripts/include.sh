#!/bin/sh

function check ()
{
    if [ $1 != 0 ]; then
        error "=("
        sleep 1
        exit 1
    fi
    sleep 0.2
}

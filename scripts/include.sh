#!/bin/sh

function check ()
{
    if [ $1 != 0 ]; then
        echo ">>> =("
        sleep 1
        exit 1
    fi
}

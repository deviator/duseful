#!/bin/bash

if [ ! -d ".dpack" ]; then
    mkdir .dpack
fi

ln -s $(pwd)/.dpack /root/.dub

exec $@
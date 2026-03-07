#!/bin/bash
docker run -it --rm \
    --net=host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:/tmp/.Xauthority \
    --device /dev/dri:/dev/dri \
    ghcr.io/ksimuk/ff356:latest "$1"

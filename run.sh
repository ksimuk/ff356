docker run -it --rm \                8.9s  Sat 07 Mar 2026 21:52:53 GMT
                           --net=host \
                           -e DISPLAY=$DISPLAY \
                           -v /tmp/.X11-unix:/tmp/.X11-unix \
                           -v $XAUTHORITY:/tmp/.Xauthority \
                           --device /dev/dri:/dev/dri \
                           firefox-ancient "http://192.168.175.5"

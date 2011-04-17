#!/bin/bash

DEFAULT_SESSION="dwm"

redshift -l 50.9:5.8 -t 5700:3600 -m vidmode &
urxvtd -q -o -f

xset +fp /usr/share/fonts/local &
xset fp rehash &

wmname LG3D
xsetroot -cursor_name top_left_arrow &

feh --bg-scale /home/ben/.xmonad/haskell.png

if [ "$1" == "" ]; then
    $1=$DEFAULT_SESSION    
fi

case $1 in
dwm)
    (sleep 2s && conky -c /home/ben/.xmonad/conky.conf | dzen2 -expand l -x '0' -y '0' -h '12' -ta r -fg 'grey' -bg '#161616'  -fn '-*-terminus-medium-r-*-*-10-*-*-*-*-*-*-*' ) &
    ck-launch-session dwm
    ;;
i3)
    exec conky -c /home/ben/.xmonad/conky.conf | i3-wsbar -c "dzen2 -x %x -dock -fn -*-profont-*-*-*-*-11-*-*-*-*-*-*-* -ta l -w 1440" &
    exec ck-launch-session i3
    ;;
xmonad)
    sh /home/ben/.xmonad/dzconky &
    exec ck-launch-session xmonad
    ;;
*)
    exec ck-launch-session $1
    ;;
esac



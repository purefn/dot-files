#!/bin/bash
 
# Set up an icon tray
 
EXECTRAYER=$(ps -A | grep trayer | wc -l)
if [ $EXECTRAYER != 0 ]; then
	killall trayer
fi
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 10 --transparent true --alpha 0 --tint 0x000000 --height 12 &
 
# Fire up apps
 

EXECPIDGIN=$(ps -A | grep pidgin | wc -l)
if [ $EXECPIDGIN = 0 ]; then
    pidgin &
fi

EXECTOMBOY=$(ps -A | grep tomboy | wc -l)
if [ $EXECTOMBOY = 0 ]; then
    tomboy &
fi

EXECSHUTTER=$(ps -A | grep shutter | wc -l)
if [ $EXECSHUTTER = 0 ]; then
    shutter --min_at_startup &
fi
 
if [ -x /usr/bin/nm-applet ] ; then
    EXECNMAPPLET=$(ps -A | grep nm-applet | wc -l)
    if [ $EXECNMAPPLET = 0 ]; then
        nm-applet --sm-disable &
    fi
fi
 
if [ -x /usr/bin/gnome-power-manager ] ; then
   sleep 3
   gnome-power-manager &
fi
 

#!/bin/bash
 
# Set up an icon tray
 
EXECTRAYER=$(ps -A | grep trayer | wc -l)
if [ $EXECTRAYER != 0 ]; then
  killall trayer
fi
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 15 --transparent true --alpha 0 --tint 0x050505 --height 18 &
 
# Fire up apps
 

EXECPIDGIN=$(ps -A | grep pidgin | wc -l)
if [ $EXECPIDGIN = 0 ]; then
  pidgin &
fi

EXECGNOTE=$(ps -A | grep gnote | wc -l)
if [ $EXECGNOTE = 0 ]; then
  gnote &
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
 
if [ -x /usr/bin/xfce4-power-manager ] ; then
  xfce4-power-manager &
fi

if [ -x /usr/bin/keepassx ] ; then
   keepassx &
fi
 
if [ -x /usr/bin/dropbox ] ; then
  dropbox start
fi

if [ -x /usr/bin/pasystray ] ; then
  pasystray &
fi

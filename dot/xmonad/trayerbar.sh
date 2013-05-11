#!/bin/bash
 
# Set up an icon tray
 
EXECTRAYER=$(ps -A | grep trayer | wc -l)
if [ $EXECTRAYER != 0 ]; then
  killall trayer
fi
trayer --edge bottom --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 15 --transparent true --alpha 0 --tint 0x050505 --height 18 &
 
# Fire up apps
 

if [ -x /usr/bin/pidgin ] ; then
  EXECPIDGIN=$(ps -A | grep pidgin | wc -l)
  if [ $EXECPIDGIN = 0 ]; then
    pidgin &
  fi
fi

if [ -x /usr/bin/gnote ] ; then
  EXECGNOTE=$(ps -A | grep gnote | wc -l)
  if [ $EXECGNOTE = 0 ]; then
    gnote &
  fi
fi

if [ -x /usr/bin/shutter ] ; then
  EXECSHUTTER=$(ps -A | grep shutter | wc -l)
  if [ $EXECSHUTTER = 0 ]; then
    shutter --min_at_startup &
  fi
fi
 
if [ -x /usr/bin/nm-applet ] ; then
  EXECNMAPPLET=$(ps -A | grep nm-applet | wc -l)
  if [ $EXECNMAPPLET = 0 ]; then
      nm-applet --sm-disable &
  fi
fi
 
if [ -x /usr/bin/xfce4-power-manager ] ; then
  EXECPM=$(ps -A | grep xfce4-power-manager | wc -l)
  if [ $EXECPM = 0 ]; then
    xfce4-power-manager &
  fi
fi

if [ -x /usr/bin/keepassx ] ; then
  EXECKEEPASSX=$(ps -A | grep keepassx | wc -l)
  if [ $EXECKEEPASSX = 0 ]; then
    keepassx &
  fi
fi
 
if [ -x /usr/bin/dropboxd ] ; then
  EXECDROPBOX=$(ps -A | grep dropboxd | wc -l)
  if [ $EXECDROPBOX = 0 ]; then
    dropboxd &
  fi
fi

if [ -x /usr/bin/pasystray ] ; then
  EXECPA=$(ps -A | grep pasystray | wc -l)
  if [ $EXECPA = 0 ]; then
    pasystray &
  fi
fi

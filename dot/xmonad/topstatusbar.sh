#!/usr/bin/env bash
 
EXECTAFFYBAR=$(ps -A | grep '[t]affybar' | wc -l)
if [ $EXECTAFFYBAR != 0 ]; then
  exit
fi
taffybar &

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

if [ -x `which deluge` ] ; then
  deluge &
fi

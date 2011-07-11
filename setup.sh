#!/bin/bash

resolve_links() {
  L=$1
  while [ -h "$L" ] ; do
    ls=`ls -ld "$L"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
      L="$link"
    else
      L="`dirname "$L"`/$link"
    fi
  done
  echo -n $L
}

make_fully_qualified() {
  saveddir=`pwd`
  if [ -f $1 ]
  then
    echo -n `cd $(dirname "$1") && pwd`/`basename "$1"`
  else
    echo -n `cd "$1" && pwd`
  fi

  cd $saveddir
}

DOT=`make_fully_qualified "$(dirname "$(resolve_links "$0")")/dot"`

for f in $DOT/*
do
  DST="$HOME/."`basename $f`
  if [ -e "$DST" ]
  then
    if [ -h "$DST" ]
    then
      if [ "$(make_fully_qualified "$(resolve_links "$DST")")" = "$f" ]
      then
        echo Skipping already setup "$DST"
      else
        echo Making backup and linking $DST
        mv "$DST" "$DST.bck"
        ln -sf "$f" "$DST"
      fi
    else
      echo Making backup and linking $DST
      mv "$DST" "$DST.bck"
      ln -sf "$f" "$DST"
    fi
  else
    echo Linking $DST
    ln -sf "$f" "$DST"
  fi
done


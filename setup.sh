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

make_dir_fully_qualified() {
  saveddir=`pwd`
  D=`cd "$1" && pwd`
  cd $saveddir
  echo -n $D
}

DOT=`make_dir_fully_qualified "$(dirname "$(resolve_links "$0")")/dot"`

for f in $DOT/*
do
  DST="$HOME/."`basename $f`
  if [ -e "$DST" ]
  then
    if [ "-h \"$DST\"" -a "`resolve_links \"$DST\"` -eq \"$DST.bck\"" ]
    then
      echo Skipping already setup "$DST"
    else
      mv "$DST" "$DST.bck"
    fi
  fi

  ln -sf "$f" "$DST"
done


#!/bin/bash

if [ -f "$YONA_DATA/RUNNING_PID" ];then
  rm $YONA_DATA/RUNNING_PID
  echo "*** [rm] $YONA_DATA/RUNNING_PID ***"
fi

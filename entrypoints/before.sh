#!/bin/bash

if [ -f "/yona/release/yona/RUNNING_PID" ];then
  rm /yona/release/yona/RUNNING_PID
  echo "*** [rm] /yona/release/yona/RUNNING_PID ***"
fi

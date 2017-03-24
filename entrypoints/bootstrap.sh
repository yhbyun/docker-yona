#!/bin/bash
set -e

if [ -n "$BEFORE_SCRIPT" ]; then
  set +e
  echo "*** [RUN BEFORE_SCRIPT] ***"
  chmod +x /yona/entrypoints/$BEFORE_SCRIPT
  /bin/bash /yona/entrypoints/$BEFORE_SCRIPT
  echo "*** [DONE BEFORE_SCRIPT] ***"
  set -e
fi

echo "*** Straing container yona bin ... ***"
cd /yona/release/yona; bin/yona

# echo "$@"
# exec "$@"

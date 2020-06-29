#!/bin/bash
GSTREAMHOSTNO=$(cat ./_UpdateMoonlightQtGamesList.sh | grep '^GSTREAMHOSTNO="' | cut -d "\"" -f2)
STREAMINGHOST="$(cat ~/.config/Moonlight\ Game\ Streaming\ Project/Moonlight.conf | grep "^$GSTREAMINGHOSTNO" | grep "\\localaddress=" | cut -d "=" -f2 | sed "s/ *$//g")"
#echo "$STREAMINGHOST"
/usr/bin/moonlight-qt quit $STREAMINGHOST 

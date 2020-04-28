#!/bin/bash

if [ "$1" == --help ]
then
  echo "Usage: ./appdistribution.sh <firebase_ci_token> <groups_file> [--build]"
else

  if [[ "$3" == --build ]]
  then
    flutter clean
    flutter build apk
  fi

  firebase appdistribution:distribute build/app/outputs/apk/release/app-release.apk \
  --app 1:100898335413:android:88a8670f87c5c1ea8cacfc \
  --token "$1" \
  --release-notes-file android/distribution/release-notes.txt \
  --groups-file "$2" \

fi

#!/usr/bin/env bash

flutter generate
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "Code Regenerated!"

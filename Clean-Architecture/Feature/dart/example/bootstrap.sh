#!/usr/bin/env bash
set -euo pipefail
flutter create . --platforms=android,ios,web,linux,macos,windows
flutter pub get
printf '
Project prepared. Start the JavaScript API, then run Flutter with API_BASE_URL.
'

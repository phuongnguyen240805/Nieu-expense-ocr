#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION=3.47.6
FLUTTER_DIR="${TMPDIR:-/tmp}/expense-flutter-${FLUTTER_VERSION}"
if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi
export PATH="${FLUTTER_DIR}/bin:${PATH}"
flutter config --enable-web --no-analytics
flutter pub get
dart scripts/setup_web.dart
flutter build web --release

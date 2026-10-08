#!/usr/bin/env bash
# Build, boot the simulator, open its window, install and launch the app. Prints build result + launch status only.
#   scripts/run.sh                 build, install, launch on $SIM
#   SIM="iPhone 17" scripts/run.sh another simulator
source "$(dirname "$0")/_env.sh"
APP_PATH="$DERIVED_DATA/Build/Products/Debug-iphonesimulator/$APP_NAME.app"

"$ROOT/scripts/build.sh" || exit $?

xcrun simctl boot "$SIM" 2>/dev/null
if ! xcrun simctl bootstatus "$SIM" -b >/dev/null 2>&1; then
    echo "--- run: FAILED | simulator '$SIM' did not boot ---"
    exit 1
fi
open -b com.apple.dt.Devices

BUNDLE_ID="$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$APP_PATH/Info.plist")"
if ! xcrun simctl install "$SIM" "$APP_PATH"; then
    echo "--- run: FAILED | install on '$SIM' ---"
    exit 1
fi
if ! xcrun simctl launch --terminate-running-process "$SIM" "$BUNDLE_ID" >/dev/null; then
    echo "--- run: FAILED | launch $BUNDLE_ID on '$SIM' ---"
    exit 1
fi
echo "--- run: SUCCESS | $BUNDLE_ID on '$SIM' ---"

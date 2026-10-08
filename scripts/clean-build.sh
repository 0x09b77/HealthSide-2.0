#!/usr/bin/env bash
# Clean build: removes build/ and Xcode's DerivedData for this project, re-resolves packages for Xcode, then runs build.sh.
source "$(dirname "$0")/_env.sh"
XCODE_DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"

echo "--- clean ---"
rm -rf "$ROOT/build"
echo "removed build/"
for dir in "$XCODE_DERIVED_DATA"/"$APP_NAME"-*; do
    [ -d "$dir" ] || continue
    rm -rf "$dir"
    echo "removed ${dir/#$HOME/~}"
done

mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/resolve.log"
for attempt in 1 2; do
    run_xcodebuild "$LOG" -resolvePackageDependencies -project "$PROJECT" -scheme "$SCHEME"
    [ "$XCB_STATUS" -eq 0 ] && break
done
echo "--- resolve packages (Xcode): $(result_label "$XCB_STATUS" "$XCB_TIMED_OUT") | full log: build/logs/resolve.log ---"
[ "$XCB_STATUS" -eq 0 ] || exit "$XCB_STATUS"

exec "$ROOT/scripts/build.sh"

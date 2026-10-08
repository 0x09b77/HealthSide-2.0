#!/usr/bin/env bash
# Shared settings for build/test scripts (bash only). Override via env, e.g. SIM="iPhone 17" scripts/build.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="HealthSide"
PROJECT="$ROOT/$APP_NAME.xcodeproj"
SCHEME="${SCHEME:-$APP_NAME}"
KIT_NAME="HealthSideKit"
KIT_DIR="$ROOT/Packages/$KIT_NAME"
SIM="${SIM:-iPhone 18 Pro}"
DESTINATION="platform=iOS Simulator,name=$SIM"
DERIVED_DATA="$ROOT/build/DerivedData"
LOG_DIR="$ROOT/build/logs"
TIMEOUT="${TIMEOUT:-300}" # seconds; xcodebuild is killed after this
mkdir -p "$LOG_DIR"

# run_xcodebuild <log> <xcodebuild args...>
# Runs xcodebuild with output to <log>, killing it after $TIMEOUT seconds.
# Sets XCB_STATUS (exit code) and XCB_TIMED_OUT (0/1).
run_xcodebuild() {
    local log="$1"
    shift
    local marker
    marker="$(mktemp)"
    xcodebuild "$@" >"$log" 2>&1 &
    local pid=$!
    (
        sleep "$TIMEOUT"
        if kill -0 "$pid" 2>/dev/null; then
            echo 1 >"$marker"
            kill -TERM "$pid" 2>/dev/null
        fi
    ) 2>/dev/null &
    local watcher=$!
    wait "$pid"
    XCB_STATUS=$?
    pkill -P "$watcher" 2>/dev/null
    kill "$watcher" 2>/dev/null
    wait "$watcher" 2>/dev/null
    XCB_TIMED_OUT=0
    if [ -s "$marker" ]; then XCB_TIMED_OUT=1; fi
    rm -f "$marker"
}

# Prints unique compiler errors and up to 10 warnings from our own sources.
print_diagnostics() {
    local log="$1"
    echo "--- errors ---"
    grep -E "^/.*: error: " "$log" | sed "s|$ROOT/||" | sort -u | head -30
    echo "--- warnings (top 10, own sources) ---"
    grep -E "^$ROOT/($APP_NAME[A-Za-z]*|Packages)/.*: warning: " "$log" | sed "s|$ROOT/||" | sort -u | head -10
}

# Prints the package's scheme: Xcode adds "<name>-Package" (all targets + tests) once the package has more than one scheme.
kit_scheme() {
    local schemes
    schemes="$(cd "$KIT_DIR" && xcodebuild -list 2>/dev/null)"
    if printf '%s\n' "$schemes" | grep -Eq "^[[:space:]]+$KIT_NAME-Package$"; then
        echo "$KIT_NAME-Package"
    else
        echo "$KIT_NAME"
    fi
}

# result_label <status> <timed_out>
result_label() {
    if [ "$2" -eq 1 ]; then
        echo "TIMEOUT after ${TIMEOUT}s"
    elif [ "$1" -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILED
    fi
}

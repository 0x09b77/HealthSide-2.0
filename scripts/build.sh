#!/usr/bin/env bash
# Build for the simulator. Prints errors/warnings + result only; full log in build/logs/build.log.
#   scripts/build.sh          the app (builds the linked HealthSideKit modules too)
#   scripts/build.sh -kit     only the HealthSideKit package
source "$(dirname "$0")/_env.sh"
LOG="$LOG_DIR/build.log"

case "${1:-}" in
    "")
        LABEL="build"
        run_xcodebuild "$LOG" build \
            -project "$PROJECT" -scheme "$SCHEME" -destination "$DESTINATION" \
            -derivedDataPath "$DERIVED_DATA" -skipMacroValidation
        ;;
    -kit)
        LABEL="build $KIT_NAME"
        KIT_SCHEME="$(kit_scheme)"
        cd "$KIT_DIR" || exit 1
        run_xcodebuild "$LOG" build \
            -scheme "$KIT_SCHEME" -destination "$DESTINATION" \
            -derivedDataPath "$DERIVED_DATA" -skipMacroValidation
        ;;
    *)
        echo "unknown option: $1"
        exit 2
        ;;
esac

print_diagnostics "$LOG"
echo "--- $LABEL: $(result_label "$XCB_STATUS" "$XCB_TIMED_OUT") | full log: build/logs/build.log ---"
exit "$XCB_STATUS"

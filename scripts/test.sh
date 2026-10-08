#!/usr/bin/env bash
# Run tests. Prints failures + counts only; full log in build/logs/test.log.
#   scripts/test.sh                          unit tests (<APP_NAME>Tests)
#   scripts/test.sh -only RouterTests        one suite (or Suite/test())
#   scripts/test.sh -ui                      UI tests (<APP_NAME>UITests)
#   scripts/test.sh -kit                     all HealthSideKit package tests
#   scripts/test.sh -kit -only CoreTests     one package test target (or Target/Suite)
source "$(dirname "$0")/_env.sh"
LOG="$LOG_DIR/test.log"
TARGET="${APP_NAME}Tests"
ONLY=""
KIT=0

while [ $# -gt 0 ]; do
    case "$1" in
        -ui) TARGET="${APP_NAME}UITests" ;;
        -kit) KIT=1 ;;
        -only)
            ONLY="$2"
            shift
            ;;
        *)
            echo "unknown option: $1"
            exit 2
            ;;
    esac
    shift
done
if [ "$KIT" -eq 1 ]; then
    FILTER="$ONLY"
    LABEL="$KIT_NAME${ONLY:+/$ONLY}"
else
    FILTER="$TARGET${ONLY:+/$ONLY}"
    LABEL="$FILTER"
fi
# Fresh temp path each run: xcodebuild refuses to overwrite an existing bundle.
RESULT_BUNDLE="$(mktemp -d)/test.xcresult"

# Parallel testing clones the simulator, which can take minutes to boot; run on the booted one instead.
if [ "$KIT" -eq 1 ]; then
    KIT_SCHEME="$(kit_scheme)"
    cd "$KIT_DIR" || exit 1
    run_xcodebuild "$LOG" test \
        -scheme "$KIT_SCHEME" -destination "$DESTINATION" \
        -derivedDataPath "$DERIVED_DATA" -skipMacroValidation \
        -parallel-testing-enabled NO \
        ${FILTER:+-only-testing:"$FILTER"} -resultBundlePath "$RESULT_BUNDLE"
else
    run_xcodebuild "$LOG" test \
        -project "$PROJECT" -scheme "$SCHEME" -destination "$DESTINATION" \
        -derivedDataPath "$DERIVED_DATA" -skipMacroValidation \
        -parallel-testing-enabled NO \
        -only-testing:"$FILTER" -resultBundlePath "$RESULT_BUNDLE"
fi

print_diagnostics "$LOG"
echo "--- failures ---"
# Failure messages and counts are not in the log, only in the result bundle.
COUNTS="passed: ?, failed: ?"
if [ -d "$RESULT_BUNDLE" ]; then
    COUNTS="$(SUMMARY="$(xcrun xcresulttool get test-results summary --path "$RESULT_BUNDLE" 2>/dev/null)" python3 <<'PY'
import json, os, sys

try:
    data = json.loads(os.environ.get("SUMMARY", ""))
except ValueError:
    print("passed: ?, failed: ?")
    raise SystemExit
for failure in data.get("testFailures", [])[:20]:
    name = failure.get("testIdentifierString") or failure.get("testName", "?")
    print(f"{name}: {failure.get('failureText', '').strip()}", file=sys.stderr)
print(f"passed: {data.get('passedTests', 0)}, failed: {data.get('failedTests', 0)}")
PY
)"
fi
echo "--- tests ($LABEL): $(result_label "$XCB_STATUS" "$XCB_TIMED_OUT") | $COUNTS | full log: build/logs/test.log ---"
exit "$XCB_STATUS"

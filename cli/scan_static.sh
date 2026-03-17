#!/bin/bash
# Simulates static analysis + coverage reporting
# In a real pipeline, this would integrate with tools like SonarQube.

set -euo pipefail

usage () {
    cat << EOF
Usage: $(basename "$0") --platform <Android|iOS> [--coverage-threshold <0-100>]
Options:
    --platform              Target platform (Android or iOS) [Required]
    --coverage-threshold    Minimum code coverage percentage required (default: 80)
    -h, --help              Show this help message
EOF
    exit 1
}

PLATFORM=""
COVERAGE_THRESHOLD=80

while [[ $# -gt 0 ]]; do
    case "$1" in
        --platform)
            PLATFORM="$2"
            if [[ "$PLATFORM" != "Android" && "$PLATFORM" != "iOS" ]]; then
                echo "[ERROR] Invalid platform: '${PLATFORM}'"
                usage
            fi
            shift 2
            ;;
        --coverage-threshold)
            COVERAGE_THRESHOLD="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "[ERROR] Unknown argument: $1"
            usage
            ;;
    esac
done

if [[ -z "$PLATFORM" ]]; then
    echo "[ERROR] Missing required argument: --platform"
    usage
fi

echo "Running static analysis"
echo "Platform:             $PLATFORM"
echo "Coverage threshold:   ${COVERAGE_THRESHOLD}%"
echo ""

echo "Running code quality scan..."
sleep 0.5
echo "Code duplication:         2.5%    [OK]"
echo "Cyclomatic complexity:    21      [OK]"
echo "Code smells:              9       [OK]"
echo "Maintainability rating:   A       [OK]"

COVERAGE=94
echo ""
echo "Running coverage analysis..."
sleep 0.5
echo "Line coverage:      ${COVERAGE}%"
echo "Branch coverage:    89%"
echo "Function coverage:  91%"
echo "Path coverage:      68%"
echo ""

if [[ $COVERAGE -lt $COVERAGE_THRESHOLD ]]; then
    echo "[ERROR] Coverage ${COVERAGE}% is below threshold of ${COVERAGE_THRESHOLD}% - pipeline halted"
    exit 1
fi

echo "Static analysis passed"
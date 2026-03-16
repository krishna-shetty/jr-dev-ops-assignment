#!/bin/bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") --platform <Android|iOS> --project-name <name> [--version <version> --profile] 

Options:
  --platform        Target platform (Android or iOS) [Required]
  --project-name    Name to give the build apk [Required]
  --version         Output build directory
  --profile         Include build profiling data
  -h, --help        Show this help message
EOF
  exit 1
}

PLATFORM=""
APP_NAME=""
VERSION=""
PROFILE="false"

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
    --project-name )
      APP_NAME="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --profile)
      PROFILE="true"
      shift 1
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
if [[ -z "$APP_NAME" ]]; then
  echo "[ERROR] Missing required argument: --project-name"
  usage
fi

BUILD_DIR=build/$PLATFORM
mkdir -p $BUILD_DIR

echo "Starting build"
echo "App Name: $APP_NAME"
echo "Version: $VERSION"
echo "Platform: $PLATFORM"

APP_TYPE=""
ASSET_TYPE=""
ASSET_PATH=""
VERSION_APPEND=""

if [[ "$PLATFORM" == "Android" ]]; then
  APP_TYPE="apk"
  ASSET_TYPE="dat"
  ASSET_PATH="$BUILD_DIR"
elif [[ "$PLATFORM" == "iOS" ]]; then
  APP_TYPE="ipa"
  ASSET_TYPE="asset"
  ASSET_PATH="${BUILD_DIR}/Assets"
fi

if ! [[ -z "$VERSION" ]]; then
  VERSION_APPEND="-${VERSION}"
fi

APK_NAME="${BUILD_DIR}/${APP_NAME}${VERSION_APPEND}.${APP_TYPE}"

echo "Building ${APK_NAME} ..."
touch "${APK_NAME}"

echo "Generating assets..."
mkdir -p $ASSET_PATH
for i in {1..10}
do
    ASSET_NAME="asset-${i}"
    echo "Building ${ASSET_NAME}.${ASSET_TYPE} ..."
    
    # Simulate build
    sleep 0.25
    
    touch "${ASSET_PATH}/${ASSET_NAME}.${ASSET_TYPE}"
    
    if [[ "$PROFILE" == "true" ]]; then      
      # Simulate Profiling
      sleep 1.5
      touch "${BUILD_DIR}/${ASSET_NAME}.pro"
    fi
done

echo "Build completed:"
ls -la $BUILD_DIR
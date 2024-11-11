#!/usr/bin/env sh

set -e

CHANNEL_NAME=$1
IMGPKG_BUNDLE_IMAGE=$2
BEARER_TOKEN=$3
BASE_PATH=$4

mkdir -p "$BASE_PATH"
cd "$BASE_PATH"
VENDIR_FILE="vendir.yml"

if [ ! -f "$VENDIR_FILE" ]; then
yq - > "$VENDIR_FILE" << 'EOF'
---
apiVersion: vendir.k14s.io/v1alpha1
kind: Config
EOF
fi

yq -i "
  .directories = .directories // []
    | .directories = .directories + [{\"path\": \"channels\", \"contents\": []}]
    | .directories |= unique_by(.path)
    | with(
      .directories[] | select(.path == \"channels\");
      .contents = [{\"path\": \"$CHANNEL_NAME\", \"imgpkgBundle\": {\"image\": \"$IMGPKG_BUNDLE_IMAGE\"}}] + .contents
        | .contents |= unique_by(.path)
    )
    | .directories |= sort_by(.path == \"channels\" | not)
" "$VENDIR_FILE"

if [ -n "$BEARER_TOKEN" ]; then
  IMGPKG_TOKEN="$BEARER_TOKEN" vendir sync
else
  vendir sync
fi

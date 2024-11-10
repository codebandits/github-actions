#!/usr/bin/env sh

if ! echo "$1" | grep -q "^http"; then
  IMAGE_REPOSITORY_URL="https://$1"
else
  IMAGE_REPOSITORY_URL="$1"
fi
BEARER_TOKEN=$2
INITIAL_NUMBER=${3}
TAG_PREFIX=${4}

if [ -n "$BEARER_TOKEN" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${BEARER_TOKEN}\""
else
  AUTH_HEADER=""
fi

TAGS=$(curl -s $AUTH_HEADER "${IMAGE_REPOSITORY_URL}/tags/list" | jq -r '.tags[]' || echo "")

if [ -z "$TAGS" ]; then
  echo "No existing tags were found. Using initial tag number ${INITIAL_NUMBER}."
  NEXT_TAG_NUMBER=$INITIAL_NUMBER
else
  HIGHEST_TAG=$(echo "$TAGS" | grep -Eo "${TAG_PREFIX}[0-9]+" | sort -V | tail -n 1)

  if [ -z "$HIGHEST_TAG" ]; then
    echo "No existing tags with the specified prefix were found. Using initial tag number ${INITIAL_NUMBER}."
    NEXT_TAG_NUMBER=$INITIAL_NUMBER
  else
    HIGHEST_TAG_NUMBER=$(echo "$HIGHEST_TAG" | grep -Eo '[0-9]+')
    NEXT_TAG_NUMBER=$((HIGHEST_TAG_NUMBER + 1))
  fi
fi

NEXT_TAG="${TAG_PREFIX}${NEXT_TAG_NUMBER}"
echo "Next tag: $NEXT_TAG"
echo "tag=$NEXT_TAG" >> $GITHUB_OUTPUT
echo "number=$NEXT_TAG_NUMBER" >> $GITHUB_OUTPUT

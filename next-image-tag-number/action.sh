#!/usr/bin/env sh

set -e

REPOSITORY_API_URL=$1
IMAGE_NAME=$2
BEARER_TOKEN=$3
INITIAL_NUMBER=$4
TAG_PREFIX=$5

if [ -n "$BEARER_TOKEN" ]; then
  TAGS_LIST_JSON=$(curl -fsS -H "Authorization: Bearer ${BEARER_TOKEN}" "${REPOSITORY_API_URL}/${IMAGE_NAME}/tags/list")
else
  TAGS_LIST_JSON=$(curl -fsS "${REPOSITORY_API_URL}/${IMAGE_NAME}/tags/list")
fi

TAGS=$(echo "$TAGS_LIST_JSON" | jq -r '.tags[]' || echo "")

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

#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    echo "Usage: ${0##*/} <path-to-flac-file>"
    exit 1
fi

TARGET_FILE="$1"

# 1. Validate file exists and is actually a FLAC file
if [[ ! -f "$TARGET_FILE" ]]; then
    echo "Error: File '$TARGET_FILE' not found."
    exit 1
fi

if [[ $(file --mime-type -b "$TARGET_FILE") != "audio/flac" ]]; then
    echo "Error: '$TARGET_FILE' is not a valid FLAC file."
    exit 1
fi

TEMP_TAGS=$(mktemp -t flac-tags.XXXXXX.txt)
trap 'rm -f "$TEMP_TAGS"' EXIT

# Export current tags
if ! metaflac --export-tags-to="$TEMP_TAGS" "$TARGET_FILE"; then
    echo "Error: Failed to export tags."
    exit 1
fi

sed -i -e '/^LYRICS=/I,/^[A-Z_]*=/ { /^LYRICS=/I! { /^[A-Z_]*=/!d }; /^LYRICS=/Id }' "$TEMP_TAGS"

${EDITOR:-nano} "$TEMP_TAGS"

read -rp "Modify $TARGET_FILE? This will overwrite existing metadata. [y/N]" confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "Changes discarded."
    exit 0
fi

if metaflac --remove-all-tags-except=LYRICS --import-tags-from="$TEMP_TAGS" "$TARGET_FILE"; then
    echo "Success: Tags updated."
else
    echo "Error: Failed to import tags."
    exit 1
fi

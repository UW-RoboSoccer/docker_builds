#!/bin/bash
set -euo pipefail

force=false

# Parse arguments for -f flag
while getopts "f" opt; do
    case "$opt" in
        f) force=true ;;
        *) ;;
    esac
done

echo "Searching for Docker images starting with 'uwrobosoccer/*' and tagged ':dev'..."

# Use the updated filter line to find matching images
images=$(docker images --filter "reference=uwrobosoccer/*:dev" --format "{{.Repository}}:{{.Tag}}")

# Check if any images were found
if [[ -z "$images" ]]; then
    echo "No matching images found."
    exit 0
fi

# If not forcing, ask for confirmation
if ! "$force"; then
    read -r -p "Do you want to remove these images? [Y/n] " answer
    answer=${answer:-Y}  # Default to 'Y' if no input

    case "${answer,,}" in
        y|yes)
            echo "Proceeding with removal..."
            ;;
        *)
            echo "Aborting removal."
            exit 0
            ;;
    esac
fi

# Iterate over each repository:tag and remove it
while IFS= read -r image; do
    echo "Removing image: $image"
    if "$force"; then
        docker rmi -f "$image" || echo "Failed to force remove $image"
    else
        docker rmi "$image" || echo "Failed to remove $image"
    fi
done <<< "$images"

echo "Removal of matching images completed."

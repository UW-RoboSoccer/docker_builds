#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Start message
echo -e "${GREEN}Starting Docker image build process...${NC}"

cd ~/docker_builds/dev_containers

# Loop through each subdirectory in the current directory
for d in */; do
    # Remove trailing slash for readability
    dir_name="${d%/}"

    # Check if the directory is empty
    if [ -z "$(ls -A "$d")" ]; then
        echo -e "${YELLOW}Skipping empty directory: $dir_name${NC}"
        continue
    fi

    # Check if a Dockerfile exists in the directory
    if [ -f "$d/Dockerfile" ]; then
        image_name="uwrobosoccer/${dir_name}:dev"
        echo -e "${GREEN}Building image '$image_name' from directory '$dir_name'...${NC}"
        
        # Build the Docker image with the tag :test
        docker build -t "$image_name" "$d"
        
        echo -e "${GREEN}Successfully built '$image_name'.${NC}"
    else
        echo -e "${YELLOW}No Dockerfile found in '$dir_name'. Skipping...${NC}"
    fi
done

cd -

# Completion message
echo -e "${GREEN}All applicable Docker images have been built.${NC}"

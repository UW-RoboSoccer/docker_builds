#!/usr/bin/env bash
cd ~/docker_builds

declare -A repo_mapping
while read -r src repo_url; do
  # Skip empty lines or comments
  [[ -z "$src" || "$src" == \#* ]] && continue
  repo_mapping["$src"]="git clone $repo_url $src"
done < git_repos

for src in "${!repo_mapping[@]}"; do
  if [ ! -d "$src" ]; then
    echo "Directory $src does not exist. Cloning repository..."
    eval "${repo_mapping[$src]}"
  else
    echo "Directory $src already exists, skipping clone."
  fi
done

cd -

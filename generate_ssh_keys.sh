#!/bin/bash

# This script generates SSH keys for different GitHub repositories and configures SSH to use them.

# Ensure the .ssh directory exists
mkdir -p ~/.ssh
chmod 700 ~/.ssh

repos=("navigator-api" "navigator-web" "navigator-shared")

# Loop through each repository
for repo in "${repos[@]}"; do
  key_path="$HOME/.ssh/navigator_pilot_${repo//-/_}"
  host="github-${repo}"

  # Check if the key already exists
  if [ ! -f "${key_path}" ]; then
    echo "Generating SSH key for ${repo}..."
    ssh-keygen -t rsa -b 4096 -f "${key_path}" -N "" -C "${repo}@pilot"
  else
    echo "SSH key for ${repo} already exists at ${key_path}."
  fi

  # Check if the host is already configured in ~/.ssh/config
  if ! grep -q "Host ${host}" ~/.ssh/config 2>/dev/null; then
    echo "Adding SSH config for ${host}..."
    {
      echo ""
      echo "# Config for ${repo}"
      echo "Host ${host}"
      echo "  HostName github.com"
      echo "  User git"
      echo "  IdentityFile ${key_path}"
      echo "  IdentitiesOnly yes"
      echo "  AddKeysToAgent yes"
    } >> ~/.ssh/config
  else
    echo "SSH config for ${host} already exists."
  fi
done

# Set correct permissions for the config file
chmod 600 ~/.ssh/config

echo -e "\n--- Public Keys ---"
for repo in "${repos[@]}"; do
  key_path="$HOME/.ssh/navigator_pilot_${repo//-/_}.pub"
  if [ -f "${key_path}" ]; then
    echo -e "\nPublic key for ${repo} (${key_path}):"
    cat "${key_path}"
  fi
done

echo -e "\nScript finished. Add the public keys above to your GitHub repositories."

# Start the ssh-agent if it's not running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add keys to the agent
for repo in "${repos[@]}"; do
    key_path="$HOME/.ssh/navigator_pilot_${repo//-/_}"
    ssh-add "${key_path}"
done

echo -e "\nAll keys have been added to the ssh-agent."

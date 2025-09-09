#!/bin/bash

# This script generates SSH keys for pilot repositories and configures SSH to use them.

mkdir -p ~/.ssh
chmod 700 ~/.ssh

repos=("navigator-api" "navigator-web" "navigator-shared")

for repo in "${repos[@]}"; do
  key_path="$HOME/.ssh/navigator_pilot_${repo//-/_}"
  host="github-${repo}"

  if [ ! -f "${key_path}" ]; then
    echo "Generating SSH key for ${repo}..."
    ssh-keygen -t rsa -b 4096 -f "${key_path}" -N "" -C "${repo}@pilot"
  else
    echo "SSH key for ${repo} already exists at ${key_path}."
  fi

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

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

for repo in "${repos[@]}"; do
    key_path="$HOME/.ssh/navigator_pilot_${repo//-/_}"
    ssh-add "${key_path}"
done

echo -e "\nAll keys have been added to the ssh-agent."

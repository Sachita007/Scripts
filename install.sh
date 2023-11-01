#!/bin/bash

# GitHub Pages repository URL
REPO_URL="https://sachita007.github.io/Scripts/scripts/"

# Output directory for decrypted scripts
OUTPUT_ROOT_DIR="./decrypted_scripts"

# Create the output root directory if it doesn't exist
mkdir -p "$OUTPUT_ROOT_DIR"

# Define color codes
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Function to execute a script and display the results
execute_script() {
  key="$1"
  secret="$2"
  OUTPUT_DIR="$OUTPUT_ROOT_DIR/$key"

  # Create a directory for the key if it doesn't exist
  mkdir -p "$OUTPUT_DIR"

  # Download the encrypted script and version
  echo -e "Downloading ${key}_script.sh.enc..."
  wget -q --show-progress -O "$OUTPUT_DIR/${key}_script.sh.enc" "${REPO_URL}${key}/script.sh.enc"
  echo -e "Downloading ${key}_version.json.enc..."
  wget -q --show-progress -O "$OUTPUT_DIR/${key}_version.json.enc" "${REPO_URL}${key}/version.json.enc"

  # Decrypt the script using OpenSSL
  echo -e "Decrypting ${key}_script.sh.enc..."
  openssl enc -d -aes-256-cbc -pbkdf2 -in "$OUTPUT_DIR/${key}_script.sh.enc" -out "$OUTPUT_DIR/${key}_script.sh" -k "$secret"

  # Ensure the script is executable
  chmod +x "$OUTPUT_DIR/${key}_script.sh"

  # Decrypt the version.json file using OpenSSL
  echo -e "Decrypting ${key}_version.json.enc..."
  openssl enc -d -aes-256-cbc -pbkdf2 -in "$OUTPUT_DIR/${key}_version.json.enc" -out "$OUTPUT_DIR/${key}_version.json" -k "$secret"

  # Execute the script and capture its output
  script_output=$( "$OUTPUT_DIR/${key}_script.sh" )

  # Extract version from the output message of the executed script
  version=$(echo "$script_output" | grep "Message Version" | awk -F ": " '{print $2}')
  decryption_key=$(echo "$script_output" | grep "Decryption Key" | awk -F ": " '{print $2}')

  # Extract the version from the decrypted version.json file
  expected_version=$(cat "$OUTPUT_DIR/${key}_version.json" | jq -r '.version')

  # Check if the extracted version and key match the expected values
  if [ "$version" == "$expected_version" ] && [ "$decryption_key" == "$key" ]; then
    echo -e "${GREEN}Script ${key} is correct.${RESET}"
    echo -e "${GREEN}Version: $version${RESET}"
    echo -e "${GREEN}Decryption Key: $decryption_key${RESET}"
    echo "--------------------------------------"
  else
    echo -e "${RED}Script ${key} has incorrect version or key.${RESET}"
    echo "--------------------------------------"
  fi
}

# Check if the key.json file path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <key.json>"
  exit 1
fi

# Iterate through the keys in the provided key.json file and execute the scripts
cat "$1" | jq -r 'to_entries[] | "\(.key) \(.value)"' | while read -r key secret; do
  execute_script "$key" "$secret"
done

echo "Scripts have been downloaded, decrypted, executed, and verified."
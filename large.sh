#!/bin/bash

# GitHub Pages repository URL
REPO_URL="https://sachita007.github.io/Scripts/largeScript/"

# Output directory for decrypted files
OUTPUT_ROOT_DIR="./decrypted_files"

# Create the output root directory if it doesn't exist
mkdir -p "$OUTPUT_ROOT_DIR"

# Define color codes
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Number of words to print from the decrypted text
WORDS_TO_PRINT=10


# Function to download and decrypt a text file
download_and_decrypt() {
  key="$1"

  # Determine the URL for the encrypted text file based on the key
  encrypted_file_url="${REPO_URL}${key}/encrypted.txt.enc"

  OUTPUT_DIR="$OUTPUT_ROOT_DIR"

  # Create a directory for the decrypted file if it doesn't exist
  mkdir -p "$OUTPUT_DIR"

  # Download the encrypted file
  echo -e "Downloading ${key}_encrypted.txt.enc..."
  wget -q --show-progress -O "$OUTPUT_DIR/${key}_encrypted.txt.enc" "$encrypted_file_url"

  # Retrieve the decryption key from the environment variable
  secret="${!key}"

  if [ -z "$secret" ]; then
    echo "Error: Environment variable '$key' (secret) is not set."
    exit 1
  fi

  # Decrypt the file using OpenSSL
  decrypted_file="${key}_encrypted.txt"
  echo -e "Decrypting ${key}_encrypted.txt.enc..."
  openssl enc -d -aes-256-cbc -pbkdf2 -in "$OUTPUT_DIR/${key}_encrypted.txt.enc" -out "$OUTPUT_DIR/$decrypted_file" -k "$secret"

  # Print the first $WORDS_TO_PRINT words in a single line and the total word count
  echo -e "${GREEN}First $WORDS_TO_PRINT words of decrypted content:${RESET}"
  cat "$OUTPUT_DIR/$decrypted_file" | tr ' ' '\n' | head -n $WORDS_TO_PRINT | tr '\n' ' '
  total_word_count=$(cat "$OUTPUT_DIR/$decrypted_file" | wc -w)
  echo -e "\n${GREEN}Total word count: $total_word_count ${RESET}"
}

# Check if the decryption key is provided as an argument
if [ -z "$1" ]; then
  echo "${RED}Usage: $0 <key>"
  exit 1
fi

# Call the function to download and decrypt the text file
download_and_decrypt "$1"

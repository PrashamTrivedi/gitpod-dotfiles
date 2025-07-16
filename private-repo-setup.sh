#!/bin/bash

# Private Repository Setup Script
# This script allows cloning a private repository to the home directory
# Usage: ./private-repo-setup.sh <repo-url> <directory-name>

REPO_URL="$1"
DIR_NAME="$2"

if [ -z "$REPO_URL" ] || [ -z "$DIR_NAME" ]; then
    echo "Usage: $0 <repo-url> <directory-name>"
    echo "Example: $0 https://github.com/user/private-repo.git my-private-repo"
    exit 1
fi

# Create target directory in home
TARGET_DIR="$HOME/$DIR_NAME"

# Check if directory already exists
if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists."
    echo "Do you want to remove it and clone fresh? (y/N)"
    read -r response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
        rm -rf "$TARGET_DIR"
    else
        echo "Aborting..."
        exit 1
    fi
fi

# Clone the repository
echo "Cloning $REPO_URL to $TARGET_DIR..."
git clone "$REPO_URL" "$TARGET_DIR"

if [ $? -eq 0 ]; then
    echo "Successfully cloned repository to $TARGET_DIR"
    echo "You can now access it with: cd $TARGET_DIR"
else
    echo "Failed to clone repository. Please check:"
    echo "1. The repository URL is correct"
    echo "2. You have access to the repository"
    echo "3. Your Git credentials are properly configured"
    exit 1
fi
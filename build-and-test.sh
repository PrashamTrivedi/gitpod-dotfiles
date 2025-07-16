#!/bin/bash

# Build and test script with comprehensive logging
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="./logs"
BUILD_LOG="$LOG_DIR/build_${TIMESTAMP}.log"
SETUP_LOG="$LOG_DIR/setup_${TIMESTAMP}.log"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

echo "=== Docker Build and Test Session Started at $(date) ===" | tee "$BUILD_LOG"
echo "Build log: $BUILD_LOG"
echo "Setup log: $SETUP_LOG"

# Function to log with timestamp
log_with_timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$BUILD_LOG"
}

log_with_timestamp "Starting Docker build process..."

# Build the container with detailed logging
log_with_timestamp "Building Docker container..."
docker build -t gitpod-dotfiles-test . 2>&1 | tee -a "$BUILD_LOG"

if [ $? -eq 0 ]; then
    log_with_timestamp "Docker build completed successfully"
else
    log_with_timestamp "Docker build failed!"
    exit 1
fi

# Run the container in interactive mode (not detached)
log_with_timestamp "Starting container in interactive mode..."
echo "Container will start in interactive mode. You can run commands and observe output."
echo "Setup logs will be captured in: $SETUP_LOG"

# Run container and capture setup.sh output
docker run -it --name gitpod-dotfiles-test-${TIMESTAMP} gitpod-dotfiles-test
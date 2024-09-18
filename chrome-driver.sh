#!/bin/bash

# Function to get the installed Google Chrome version
get_chrome_version() {
    google-chrome --version | awk '{print $3}'
}

# Get the installed Chrome version
CHROME_VERSION=$(get_chrome_version)
if [ -z "$CHROME_VERSION" ]; then
    echo "Google Chrome is not installed or not found in the PATH."
    exit 1
fi

# Define the URL and file paths
CHROMEDRIVER_URL="https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip"
TEMP_DIR="/tmp/chromedriver_install"
ZIP_FILE="$TEMP_DIR/chromedriver-linux64.zip"
CHROMEDRIVER_PATH="/usr/bin/chromedriver"

# Create a temporary directory
mkdir -p "$TEMP_DIR"

# Download the ChromeDriver zip file
echo "Downloading ChromeDriver for Chrome version $CHROME_VERSION..."
wget -q "$CHROMEDRIVER_URL" -O "$ZIP_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to download ChromeDriver."
    exit 1
fi

# Unzip the ChromeDriver binary
echo "Unzipping ChromeDriver..."
unzip -q "$ZIP_FILE" -d "$TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to unzip ChromeDriver."
    exit 1
fi

# List files in the temporary directory for debugging
echo "Contents of the temporary directory:"
ls -l "$TEMP_DIR"

# Find the extracted chromedriver binary
CHROMEDRIVER_BINARY=$(find "$TEMP_DIR" -name "chromedriver")
if [ -z "$CHROMEDRIVER_BINARY" ]; then
    echo "ChromeDriver binary not found in the temporary directory."
    exit 1
fi

# Move the ChromeDriver binary to /usr/bin/
echo "Installing ChromeDriver..."
sudo mv "$CHROMEDRIVER_BINARY" "$CHROMEDRIVER_PATH"
if [ $? -ne 0 ]; then
    echo "Failed to move ChromeDriver to $CHROMEDRIVER_PATH."
    exit 1
fi

# Clean up
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "ChromeDriver installation completed successfully."


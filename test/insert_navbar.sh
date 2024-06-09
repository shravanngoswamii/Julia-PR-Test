#!/bin/bash

# URL of the navigation bar HTML file
NAVBAR_URL="https://raw.githubusercontent.com/your-username/your-repo/main/navbar.html"

# Directory containing HTML files (passed as the first argument to the script)
HTML_DIR=$1

# Download the navigation bar HTML content
NAVBAR_HTML=$(curl -s $NAVBAR_URL)

# Check if the download was successful
if [ -z "$NAVBAR_HTML" ]; then
    echo "Failed to download navbar HTML"
    exit 1
fi

# Process each HTML file in the directory
for file in $(find $HTML_DIR -name "*.html"); do
    if grep -q "<body>" "$file"; then
        sed -i "/<body>/a $NAVBAR_HTML" "$file"
        echo "Updated $file"
    else
        echo "<body> tag not found in $file"
    fi
done

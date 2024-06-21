#!/bin/bash

# This script inserts a top navigation bar (e.g., `navbar.html`) into Documenter.jl generated sites. 
# The resulting output is similar to MultiDocumenter's navigation menu. The navigation menu is 
# hard-coded at the moment, which could be improved in the future. 

# URL of the navigation bar HTML file
NAVBAR_URL="https://raw.githubusercontent.com/TuringLang/turinglang.github.io/main/assets/scripts/navbar.html"

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
    # Check if the file already contains the navbar HTML to avoid duplicate insertion
    if grep -q "$NAVBAR_HTML" "$file"; then
        echo "Skipping $file, already contains navbar"
        continue
    fi

    # Read the contents of the HTML file
    file_contents=$(cat "$file")

    # Insert the navbar HTML after the <body> tag
    updated_contents="${file_contents/$'<body>'/$'<body>\n'$NAVBAR_HTML}"

    # Write the updated contents back to the file
    echo "$updated_contents" > "$file"
    echo "Updated $file"
done

#!/bin/bash
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
echo "Script directory is: $SCRIPT_DIR"

while IFS= read -r  file; do
    if [ "$file" == "${SCRIPT_DIR}" ]; then
        echo Found $file
        continue
    fi 
    find "$file" -type f | xargs -I {} cp -u {} "${SCRIPT_DIR}"
    rm -rf "$file"
done < <(find ${SCRIPT_DIR} -maxdepth 1 -type d )

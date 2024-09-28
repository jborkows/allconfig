#!/bin/bash
if [ -z "$1" ]; then
    echo "Error: No argument provided."
    echo "Usage: $0 gitub repo"
    exit 1
fi

extract_repo_name() {
    input="$1"
    
    if [[ "$input" =~ ^https?://github\.com/(.+)/(.+)$ ]]; then
        repo_name="${BASH_REMATCH[2]}"
    elif [[ "$input" =~ ^([^/]+)/([^/]+)$ ]]; then
        repo_name="${BASH_REMATCH[2]}"
    elif [[ "$input" =~ ^([^/]+)$ ]]; then
        repo_name="$input"
    else
        echo "Invalid input format: $input"
        exit 1
    fi

    echo "$repo_name"
}

REPO_NAME=$(extract_repo_name "$1")
ORG_NAME="jborkows"

if gh repo view "$ORG_NAME/$REPO_NAME" > /dev/null 2>&1; then
    echo "Repository '$ORG_NAME/$REPO_NAME' already exists."
else
    echo "Repository '$ORG_NAME/$REPO_NAME' does not exist. Creating it..."
    # Create the repository
    gh repo create "$ORG_NAME/$REPO_NAME" --public --description "Description of the repository" --confirm
    echo "Repository '$ORG_NAME/$REPO_NAME' created successfully."
fi


git remote add origin personal:$ORG_NAME/$REPO_NAME
git push --set-upstream origin master
echo "Remote 'origin' added successfully."

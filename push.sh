#!/bin/bash
# One-command push for vladws.com
# Usage:  bash push.sh
#    or:  bash push.sh "custom commit message"
# It will ask for your GitHub token (input stays hidden).

cd "/Users/vladimirwoodham-smith/Documents/Projects/Websites/Vlad Website"

read -r -s -p "Paste GitHub token, then press enter: " TOKEN
echo ""
if [ -z "$TOKEN" ]; then echo "No token entered — aborting."; exit 1; fi

REPO_URL="https://plasticfruitstudios-dev:${TOKEN}@github.com/plasticfruitstudios-dev/vlad-woodham-smith.git"

git add -A
git commit -m "${1:-Update site}"
git push "$REPO_URL" main

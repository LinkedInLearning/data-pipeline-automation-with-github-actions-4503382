#!/usr/bin/env bash
BRANCH="main"


# Save the current time into a log file
date >> ./dev/log.txt 

# Commit
p=$(pwd)
git config --global --add safe.directory $p

if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name $USER_NAME
    git config --global user.email $USER_EMAIL
    git add dev/log.txt
    git commit -m "Update the log"
    git push origin $BRANCH
else
echo "Nothing to commit..."
fi
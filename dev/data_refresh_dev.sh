#!/usr/bin/env bash
BRANCH="main"

source /opt/$VENV_NAME/bin/activate 

echo "Starting Test"

touch ./dev/test.txt 
echo "test" > ./dev/test.txt

echo "Finish"

p=$(pwd)
git config --global --add safe.directory $p

if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name $USER_NAME
    git config --global user.email $USER_EMAIL
    git add dev/*
    git commit -m "Testing"
    git push origin $BRANCH
else
echo "Nothing to commit..."
fi
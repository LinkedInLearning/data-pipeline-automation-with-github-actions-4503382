#!/usr/bin/env bash

Rscript -e "source('./dev/04_data_refresh.R')"

echo "Finish"

git config --global --add safe.directory /__w/data-pipeline-automation-with-github-actions-4503382/data-pipeline-automation-with-github-actions-4503382

if [[ "$(git status --porcelain)" != "" ]]; then
    echo "Set user name"
    git config --global user.name 'RamiKrispin'
    echo "Set user email"
    git config --global user.email 'ramkrisp@umich.edu'
    echo "Add new files"
    git add csv/*
    git add metadata/*
    echo "Commit"
    git commit -m "Auto update of the data"
    git push origin stg
else
echo "Nothing to commit..."
fi
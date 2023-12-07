#!/usr/bin/env bash

Rscript -e "source('./dev/04_data_refresh.R')"

echo "Finish"
p=$(pwd)
git config --global --add safe.directory $p

if [[ "$(git status --porcelain)" != "" ]]; then
    git config --global user.name 'RamiKrispin'
    git config --global user.email 'ramkrisp@umich.edu'
    git add csv/*
    git add metadata/*
    git commit -m "Auto update of the data"
    git push origin stg
else
echo "Nothing to commit..."
fi
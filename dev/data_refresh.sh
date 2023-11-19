#!/usr/bin/env bash

Rscript -e "source('./dev/04_data_refresh.R')"


# if [[ "$(git status --porcelain)" != "" ]]; then
#     git config --global user.name 'RamiKrispin'
#     git config --global user.email 'ramkrisp@umich.edu'
#     git add docs/*
#     git add data/*
#     git commit -m "Auto update of the data"
#     git push origin main
# else
# echo "Nothing to commit..."
# fi
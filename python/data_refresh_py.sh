#!/usr/bin/env bash
source /opt/$VENV_NAME/bin/activate 

rm -rf ./python/data_refresh_py_files
rm ./python/data_refresh_py.html
quarto render ./python/data_refresh_py.qmd --to html

rm -rf docs/data_refresh_python/
mkdir docs/data_refresh_python
cp ./python/data_refresh_py.html ./docs/data_refresh_python/
cp -R ./python/data_refresh_py_files ./docs/data_refresh_python/

echo "Finish"

# p=$(pwd)
# git config --global --add safe.directory $p

# echo "Finish"
# p=$(pwd)
# git config --global --add safe.directory $p

# if [[ "$(git status --porcelain)" != "" ]]; then
#     git config --global user.name 'RamiKrispin'
#     git config --global user.email 'ramkrisp@umich.edu'
#     git add csv/*
#     git add metadata/*
#     git commit -m "Auto update of the data"
#     git push origin stg
# else
# echo "Nothing to commit..."
# fi
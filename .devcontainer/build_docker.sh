#!/bin/bash

echo "Build the docker"

docker build . -f Dockerfile.dev \
               --progress=plain \
               --build-arg PROJECT_NAME="EIA Data Automation" \
               --build-arg VENV_NAME="LINKEDIN_LEARNING" \
               --build-arg R_VERSION_MAJOR=4 \
               --build-arg R_VERSION_MINOR=3 \
               --build-arg R_VERSION_PATCH=1 \
               --build-arg DEBIAN_FRONTEND=noninteractive \
                --build-arg CRAN_MIRROR="https://cran.rstudio.com/" \
               --build-arg QUARTO_VER=$QUARTO_VER \
               -t rkrispin/eia_data_refresh:0.0.0.9004

if [[ $? = 0 ]] ; then
echo "Pushing docker..."
docker push rkrispin/eia_data_refresh:0.0.0.9004
else
echo "Docker build failed"
fi

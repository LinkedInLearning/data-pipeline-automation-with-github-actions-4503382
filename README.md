# Data Pipeline Automation with GitHub Actions

This is the repository for the LinkedIn Learning course `Data Pipeline Automation with GitHub Actions`. The full course is available from [LinkedIn Learning][lil-course-url].

![lil-thumbnail-url]

In this course, learn how to set up workflows on GitHub Actions to automate processes with both R and Python. Instructor Rami Krispin takes you through the automation process, sharing real-world examples. He shows you how to set up a data pipeline, pull metadata from a pipeline, and deploy a live dashboard with GitHub Actions and Pages. If you’re tired of spending hours running scripts manually, or slowing down your workflow by pulling data from APIs or updating dashboards, join Rami in this course to see how automation can speed up your work.

_See the readme file in the main branch for updated instructions and information._

## Instructions

Fork this repo to follow along with the course. The course has tracks for R and Python users, and you can choose to follow one or both. The R code examples are available under the [R folder](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/tree/main/R); likewise, the Python code examples are available under the [python folder](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/tree/main/python).

This repo has VScode [setting](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/blob/main/.devcontainer/devcontainer.json) to launch the repo inside a Docker container using the Dev Containers extension. The course image was built to support amd64 CPU architecture in line with the GitHub Actions container support. Alternatively, you can install locally the required R or Python requirements using the [required_packages.R](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/blob/main/R/required_packages.R) for R and [requirements.txt](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/blob/main/.devcontainer/requirements.txt) for Python.


Throughout the course, we will work with the EIA API to pull data and metadata. The EIA API is open and free, and an API key is required to access it. To register to the API and set your key, go to the [EIA website](https://www.eia.gov/opendata/index.php) and follow the registration instructions.


For learning purposes, we store the data pipeline outputs and metadata locally, in the [csv](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/tree/main/csv) and [metadata](https://github.com/RamiKrispin/data-pipeline-automation-with-github-actions-4503382/tree/main/metadata) folders.

## Instructor

Rami Krispin

Senior Manager, Data Science and Engineering

                            

Check out my other courses on [LinkedIn Learning](https://www.linkedin.com/learning/instructors/rami-krispin?u=104).

[0]: # (Replace these placeholder URLs with actual course URLs)

[lil-course-url]: https://www.linkedin.com/learning/data-pipeline-automation-with-github-actions-using-r-and-python
[lil-thumbnail-url]: https://media.licdn.com/dms/image/D560DAQHvVdDve6puQA/learning-public-crop_675_1200/0/1713388433219?e=2147483647&v=beta&t=j2nI9zwX3eoLdPrfSxjw0I6DT_PdvT2fv5vrHHQZR8k

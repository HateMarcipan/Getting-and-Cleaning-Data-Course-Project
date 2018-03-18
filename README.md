## Getting and Cleaning Data Course Project

### Purpose of this project

This repository is created as a part of the final Getting and Cleaning Data Course Project.

As per assignment description:"The purpose of this project is to demonstrate ... ability to collect, work with, and clean a data set."

Data set used for this purpose as well as its description can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#


Files you will find in this repository are:

- README.md
- CodeBook.md - file "that describes the variables, the data, and any transformations or work that I performed to clean up the data"
- ActivityRecognitionTidy.csv - independent tidy data set which is created as a result of R script mentioned bellow
- run_analysis.R - R script that you can download and source it so that it:

1. downloads original data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to the temporary location, unzips it and reads required data;
2. re-names variables, extracts required variables only, consolidates training and test data, aggregates values as mean on required level and outputs as ActivityRecognitionTidy.csv file to folder called "data_qwerty" under your working directory.

Note: run_analys.R script requires following packages: dplyr, reshape2 and jsonlite.

# Getting And Cleaning Data Project

This project is the final assessment of the course 'Getting and Cleaning Data' on Coursera.
The purpose of this project is to demonstrate  student's ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The data from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


The goal of the assessment is to create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

From the original ReadMe document included in the datasets used in this project:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

### Datasets used in this project

* activity_labels.txt
* features.txt
* subject_test.txt
* X_test.txt
* y_test.txt
* subject_train.txt
* X_train.txt
* y_train.txt

The content of each dataset is described in the Codebook included in this repo.
These datasets can be downloaded from this link
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### This repository includes the following files

* 'ReadMe.md' file
* 'Codebook.md' file. It details the variables found in the datasets used and the final dataset generated
* 'run_analysis.R'. R script with the description of each step that lead to the generation of a tidy dataset with one variable per column, one observation per row, and column headers with names (explained the the codebook)

### Explanation of the R script
1. Setting the working directory
2. Loading packages used in this script
3. Downloading and unzipping the datasets necessary for the assessment
    * checking the content of the download folders
4. Reading the datasets used for the assessment and assign them to specific R objects
5. Setting the column names in the data frames because the original datasets have no headers
    * activity_lbl, test_partic, test_activity, train_partic and train_activity were assigned descriptive column names
    * the column names for test_set and train_set were taken from the feature.txt dataset
6. Merging datasets
    * merging test_partic + test_activity + test_set to generate a test data frame with participant Ids, activity Ids and measured test values (test_merge)
    * merging train_partic + train_activity + train_set to generate a test data frame with participant Ids, activity Ids and measured training values (test_train)
    * merging test_merge + test_train to generate a combined data frame (train_test_df)
7. Extracting the columns containing means and standard deviations
    * some of the columns extracted contain the word 'mean', but they do not contain the data needed for the assessment, so they were removed
8. Adding a column with the explanatory names of the activities (activityName)
9. Replacing the dash sign with underscores and removing the parenthesis from column names. Parenthesis are not necessary there. Dashes in the names were generating errors in the next step. Column names were replaced with more explanatory names because that would have created unnecessarily long headers. This codebook and the original downloaded files explain those names in detail
10. Removing the column where activity was represented by a number (activityId), and reordering the columns so that the column activityName is now the second column
11. Generating the independent tidy data set with the average of each variable for each activity and each subject. In this data frame, grouping was done on activity and on participant within activity. Some of the variables have three measurements, one per axis (XYZ), and were kept separated as discreet sets of observations.
12. Generating a txt file with the data frame

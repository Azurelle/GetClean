GetClean
========

Summary: Project for Coursera's "Getting and Cleaning Data"

R scripts: 

run_analysis.R

run_analysis.R is used to:

1.  Download a zip file from the course website for the UCI HAR data

2.  Create a single data frame called “df” from the following text files:

     activity_labels.txt

     features.txt 

     subject_test.txt     

     subject_train.txt

     X_test.txt

     y_test.txt

     X_train.txt  

     y_train.txt

where

activity_labels.txt:  The data in activity_labels is  used to convert the integer values of y to descriptive values.  The six activity levels are: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

features.txt: a list of column names for the response variables.  This is used to determine which columns to keep in the final dataset. i.e. just those y variables pertaining to mean and standard deviation.  There are 66 such features.

subject_test.txt and subject_train.txt:  Integer values identifying subjects 1 to 30

3.  Check for missing values (there aren’t any in the data of interest) 

4.  Check for response data not between -1 and +1.

5.  Rename the features columns so that don’t contain any blanks, dashes, brackets or slashes.  

6.  Create a comma delimited tidy data set called “meansBySubjectActivity.csv” that collapses the data such that a single row contains the means of the response variables for each subjectID/activity pair.  Since there are 30 subjects and 6 activities, there are 30x6=180 rows, and a mean for each of the 66 features.  The result is a comma delimited file.  See CodeBook.md for a description of the variables. 



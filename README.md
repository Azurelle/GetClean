GetClean
========

Summary: 

The original README file that accompanied the raw data from the "Human Activity Recognition Using Smartphones" study is called Original_UCI_HAR_ReadMeCodebook.txt in this git repository.  It provides a brief description of the study and the raw data files.    

The text file "CodeBook.md" describes the data in "meansBySubjectActivity.txt", which is the output of the R script "run_analysis.R".

This README file describes "run_analysis.R", which was used to read the raw data into R (via RStudio) and create the output file of response variable means, "meansBySubjectActivity.txt".

R scripts:  run_analysis.R

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

subject_test.txt and subject_train.txt:  Integer values identifying subjects 1 to 30.  These subjects ranged from 19 to 48 years old, and each performed the six activities described above wearing a smartphone. Numerous movement measurements were recorded and processed, and saved in two 561 feature-vectors.  Please see "Original_UCI_HAR_ReadMeCodebook.txt" for further details.   

X_test.txt, X_train.txt, y_test.txt, y_train.txt contain the 

3.  Check for missing values (there aren’t any in the data of interest) 

4.  Check for response data not between -1 and +1.

5.  Rename the features columns so that don’t contain any blanks, dashes, brackets or slashes.  

6.  Create a comma delimited tidy data set called “meansBySubjectActivity.csv” that collapses the data such that a single row contains the means of the response variables for each subjectID/activity pair.  Since there are 30 subjects and 6 activities, there are 30x6=180 rows, and a mean for each of the 66 features.  The result is a comma delimited file.  See CodeBook.md for a description of the variables. 



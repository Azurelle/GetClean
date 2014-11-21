# run_analysis.R
#
# This R script does the following:
# 1 Merges the training and the test data sets to create one data set called "df"
# 2 Extracts only the measurements on the mean and standard deviation for 
#   each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
# 5 From the dataset in step 4, creates a second, independent tidy data set with 
#   the average of each variable for each activity and each subject called 
#   "meansDF".  This is saved as a csv file to the working directory as
#   "meansBySubjectActivity.csv"

library(stats)
library(plyr)
library(reshape)
# define directorys: working dir, test data dir, training data dir)
workingDirectory <- "/Volumes/Files/_Coursera/3 Getting and Cleaning Data/Project/"
setwd(workingDirectory)
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
#download.file(fileURL, destfile="projectData.zip", method="curl")

testDir  <- paste(workingDirectory,"UCI HAR Dataset/test/",sep="")
trainDir <- paste(workingDirectory,"UCI HAR Dataset/train/",sep="")

# define filenames of files to be read in
features_filename <- paste(workingDirectory,"UCI HAR Dataset/features.txt",sep="")
activity_filename <- paste(workingDirectory,"UCI HAR Dataset/activity_labels.txt",sep="")

test_subj_filename <- paste(testDir,"subject_test.txt",sep="")
test_X_filename <- paste(testDir,"X_test.txt",sep="")
test_Y_filename <- paste(testDir,"y_test.txt",sep="")

train_subj_filename <- paste(trainDir,"subject_train.txt",sep="")
train_X_filename <- paste(trainDir,"X_train.txt",sep="")
train_Y_filename <- paste(trainDir,"y_train.txt",sep="")


# read in data from each file.
# Note: I tried to put long lines on more than one lines but RStudio console 
# won't allow it. See:
# https://support.rstudio.com/hc/communities/public/questions/200629028--rror-Strange-error-on-multi-line-pass-to-console-with-command-enter

# create dataframe for features dictionary and activity dictionary
featuresInfo <- read.table(file=features_filename, header = FALSE, col.names=c("featureID","feature"))
activityInfo <- read.table(file=activity_filename, header = FALSE, col.names=c("activityID","activity"))

# read in test data
test_subject <- read.table(file=test_subj_filename, header = FALSE, col.names=c("subjectID"))
test_Y <- read.table(file=test_Y_filename, header = FALSE, col.names=c("y"))
# Don't read in the column names in the header. They are too unweildy and will be 
# renamed in the next section.
test_X <- read.table(file=test_X_filename, header = FALSE)  #, col.names=featuresInfo$feature)

# read in training data
train_subject <- read.table(file=train_subj_filename, header = FALSE, col.names=c("subjectID"))
train_Y <- read.table(file=train_Y_filename, header = FALSE, col.names=c("y"))
# Same as for test_X above. Remove the # in the next line of code to use the  
# names given in the features.txt file for the columns of test_X.
train_X <- read.table(file=train_X_filename, header = FALSE) #, col.names=featuresInfo$feature)

# create one dataframe for test data, a second for train data, then combine into
# a single dataframe "df"
testLabel <- data.frame(rep("test",nrow(test_Y)))
trainLabel <- data.frame(rep("train",nrow(train_Y)))
names(testLabel) <- "whichDataset"
names(trainLabel) <- "whichDataset"
testDF <- cbind(testLabel, test_subject, test_Y, test_X)
trainDF <- cbind(trainLabel, train_subject, train_Y, train_X)

# create vector of indices to select just the mean and standard deviation columns
desired <- c(grep("mean\\(\\)",tolower(featuresInfo$feature),value=F),grep("std\\(\\)",tolower(featuresInfo$feature),value=F))
desiredFeatures <- featuresInfo[desired,2]

desiredFeatures <- gsub("mean","Mean",desiredFeatures)
desiredFeatures <- gsub("std","StdDev",desiredFeatures)
desiredFeatures <- gsub("_","",desiredFeatures)
desiredFeatures <- gsub("-","",desiredFeatures)
desiredFeatures <- gsub("\\(","",desiredFeatures)
desiredFeatures <- gsub("\\)","",desiredFeatures)

# are the feature names unique now that I've changed them a little bit?
length(desiredFeatures)==length(unique(desiredFeatures))

df <- rbind(testDF, trainDF)
#have a look
head(df[,c(1,2,3,4,5,6,ncol(df)-2,ncol(df)-1,ncol(df))])
# check for missing values
sum(is.na(df))
# check for out of bounds x values
n<-ncol(df)
min(df[,4:n])
max(df[,4:n])

# add a column to end of df that defines what y=1,2,3,4,5,6 means. Use activity_labels.txt dataset. 
df <- merge(df,activityInfo,by.x="y",by.y="activityID")
# extract just the columns pertaining to mean and standard deviation
df <- df[,c(1,2,3,ncol(df),desired+3)]

# rename columns of df to those in the features vector i.e. something more descriptive
names(df)[names(df)=="y"] <- "activityID"
dfColNames <- c(names(df[,1:4]), desiredFeatures)
# change the first letter of the col name (i.e. "t" or "f") to "time" or "freq"
dfColNames <- ifelse(substr(dfColNames,1,1)=="t",sub("t","time",dfColNames),sub("f","freq",dfColNames))
# assign the column name vector to the columns of df
names(df) <- dfColNames

# create separate dataset with means by subject / activity tuple
n<-ncol(df)
melted <- melt(df[,3:n],id=c("subjectID", "activity"))
meansDF <- data.frame(cast(melted, subjectID+activity~variable, mean))

write.table(meansDF, file="meansBySubjectActivity.csv", sep=",", na="NA", col.names=T, row.names=F )




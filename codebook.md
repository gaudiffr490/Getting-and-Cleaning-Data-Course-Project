Getting and Cleaning Data Course Project


The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##Download and Unzip the Data
path <- "p:/Coursera/getting and cleaning data/UCI HAR Dataset"

if (!file.exists(path)){
  dir.create(path)
}
setwd(path)
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "Dataset.zip")
unzip("Dataset.zip", exdir = "..")


Files to be used are:
 - features.txt - listing of the 561 features for the data columns in the test and train files.
 - activity_labels.txt - mapping of activities to respectiver description
 - test/subject_test.txt; train/subject_train.txt - identifies the test and train subjects for each of the observations
 - test/y_test.txt; train/y_train.txt - identifies the activity per subject for each of the observations
 - test/x_test.txt; train/x_train.txt - identifies the measurements for each observation

## Load the feature file and add columns for subject and activity
features <- data.frame(read.table("features.txt",
                                  header = FALSE, stringsAsFactors = FALSE))
features[nrow(features) + 1, ] <- c(nrow(features) + 1, "Subject")
features[nrow(features) + 1, ] <- c(nrow(features) + 1, "Activity")
features <- make.names(features[, "V2"])


## Merges the train and the test sets to create one data set and adds column names
dataTrain <- read.table("train/X_train.txt", header=FALSE, sep = "") 
dataTrain <- cbind(dataTrain, 
                   read.table("train/subject_train.txt"),
                   read.table("train/y_train.txt")) 

dataTest <- read.table("test/X_test.txt", header=FALSE, sep = "") 
dataTest <- cbind(dataTest,
                  read.table("test/subject_test.txt"),
                  read.table("test/y_test.txt")) 
colnames(dataTest) <- features
colnames(dataTrain) <- features

## Combine the train and test datasets and add column names
dataAll <- rbind(dataTrain, dataTest)


## Retain on standard deviation and mean values
std_mean <- dataAll[, grep("std()|mean()|subject|activity", features, ignore.case = TRUE)]

## Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt", 
                              header = FALSE, stringsAsFactors = FALSE)
activity_labels <- apply(activity_labels, 1, 
                         function(x) unlist(strsplit(x, split = " ")))
std_mean[,ncol(std_mean)] <- factor(as.factor(std_mean[, ncol(std_mean)]), 
                                    labels = activity_labels[2,])

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#write the new data to the file share.
write.table(data.frame(dataAverage), "tidy_data.txt", row.names = FALSE)


The tidy data set (first row is header row)  a set of variables for each activity and each subject. The files contains 180 groups where standard deviation features are averaged for each group. The resulting data table has 180 rows and 88.
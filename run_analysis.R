## This script is used to download and process the dataset for "Human Activity 
## Recognition Using Smartphones Data Set" for the Getting and Cleaning Data 
## Course Project assignment.

library( "dplyr" )
## Check existance of dataset files and download if necessary
path <- "p:/Coursera/getting and cleaning data/UCI HAR Dataset"

if (!file.exists(path)){
  dir.create(path)
}
setwd(path)
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "Dataset.zip")
unzip("Dataset.zip", exdir = "..")


## Load the feature file and add columns for subject and activity
features <- data.frame(read.table("features.txt",
                                  header = FALSE, stringsAsFactors = FALSE))
features[nrow(features) + 1, ] <- c(nrow(features) + 1, "Subject")
features[nrow(features) + 1, ] <- c(nrow(features) + 1, "Activity")
features <- make.names(features[, "V2"])


## Merges the train and the test sets to create one data set
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


## Retain only standard deviation and mean values
std_mean <- dataAll[, grep("std()|mean()|subject|activity", features, ignore.case = TRUE)]

## Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt", 
                              header = FALSE, stringsAsFactors = FALSE)
activity_labels <- apply(activity_labels, 1, 
                         function(x) unlist(strsplit(x, split = " ")))
std_mean[,ncol(std_mean)] <- factor(as.factor(std_mean[, ncol(std_mean)]), 
                                    labels = activity_labels[2,])


## Creates a second, independent tidy data set with the average of each variable
## for each activity and each subject. 
dataAverage <- std_mean %>%
  group_by(Activity, Subject) %>%
  summarize_all(funs(mean))

#write the new data to the file share.  
write.table(data.frame(dataAverage), "tidy_data.txt", row.names = FALSE)


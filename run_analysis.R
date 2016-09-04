#create a link to the dataset & download zipped file
zipfileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipfileurl, "./smartphoneactivity.zip")


#unzip it, it will create a directory
unzip("./smartphoneactivity.zip")

# create trainingdata and testdata
trainingXdata <- read.table ("./UCI HAR Dataset/train/X_train.txt")
trainingYdata <- read.table ("./UCI HAR Dataset/train/y_train.txt")
trainingSubject <- read.table ("./UCI HAR Dataset/train/subject_train.txt")
trainingdata=cbind(trainingSubject, trainingYdata, trainingXdata)


#create test data sets
testXdata <- read.table ("./UCI HAR Dataset/test/X_test.txt")
testYdata <- read.table ("./UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table ("./UCI HAR Dataset/test/subject_test.txt")
testdata=cbind(testSubject, testYdata, testXdata)


#append the training and test data sets into one: alldata
alldata <- rbind(trainingdata, testdata)


#add the column names
features <- read.table("./UCI HAR Dataset/features.txt")


#the column names are in the second column
column_names <- as.character(features[,2])
colnames(alldata) <- c("subjectid", "activity", column_names)


# get columns with mean and std
new_alldata <- alldata[,grep(".*std*.|.*mean*.|subjectid|activity", colnames(alldata))]


# use descriptive names for the activities
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
new_alldata$activity_desc <- ifelse(new_alldata$activity=="1", "Walking",
                                   ifelse(new_alldata$activity=="2", "Walking_Upstairs",
                                          ifelse(new_alldata$activity=="3", "Walking_Downstairs",
                                                 ifelse(new_alldata$activity=="4", "Sitting",
                                                        ifelse(new_alldata$activity=="5", "Standing",
                                                               ifelse(new_alldata$activity=="6", "Laying", "NA"))))))

new_alldata$activity_desc


#creating labels for activity
new_alldata$activity <- factor(new_alldata$activity, levels=activity_labels[,1], labels=activity_labels[,2] )


# create a dataset that calculates means of all variables by subjectid and activity
# melt the data and summarise it

library(dplyr)
library(reshape2)
melted_new_alldata <- melt(new_alldata, id=c("subjectid", "activity", "activity_desc"))
final_alldata <- dcast(melted_new_alldata, subjectid + activity + activity_desc ~ variable, mean)


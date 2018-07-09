###You should create one R script called run_analysis.R that does the following.

### 1. Merges the training and the test sets to create one data set.
### 2. Extracts only the measurements on the mean and standard deviation for each 
###    measurement.
### 3. Uses descriptive activity names to name the activities in the data set
### 4. Appropriately labels the data set with descriptive variable names.
### 5.From the data set in step 4, creates a second, independent tidy data set
###   with the average of each variable for each activity and each subject.

### Download data
if(!file.exists("./dataset")){
  dir.create("./dataset")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./dataset/Dataset.zip")

# Unzip dataSet
unzip(zipfile="./dataset/Dataset.zip",exdir="./dataset")


### Read the testing set:
Test_x <- read.table("~/dataset/UCI HAR Dataset/test/X_test.txt")
Test_y <- read.table("~/dataset/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("~/dataset/UCI HAR Dataset/test/subject_test.txt")


### Read the trainings set:
Train_x <-  read.table("~/dataset/UCI HAR Dataset/train/X_train.txt")
Train_y <- read.table("~/dataset/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("~/dataset/UCI HAR Dataset/train/subject_train.txt")


### Read the features data:
features <- read.table("~/dataset/UCI HAR Dataset/features.txt", 
                       header = FALSE)

### Read the activity_labels data:
activity_labels <- read.table("~/dataset/UCI HAR Dataset/activity_labels.txt", 
                              header = FALSE)

### setting column names
colnames(Test_x) <- features$V2 
colnames(Test_y) <- "activity_Id"
colnames(test_subject) <- "subject_Id"

colnames(Train_x) <- features$V2 
colnames(Train_y) <-"activity_Id"
colnames(train_subject) <- "subject_Id"

colnames(activity_labels) <- c('activity_Id','activity_type')

### merging the test and train sets
mergedTrainset <- cbind(Train_y, train_subject, Train_x)
mergedTestset <- cbind(Test_y, test_subject, Test_x)
Dataset <- rbind(mergedTrainset, mergedTestset)

colNames <- colnames(Dataset)

mean_and_std <- (grepl("activity_Id" , colNames) | grepl("subject_Id" , colNames) | 
                   grepl("mean" , colNames) |  grepl("std" , colNames))
### Extracting the measurements on the mean and standard deviation for each 
###    measurement.

MeanAndStdData <- Dataset[ , mean_and_std == TRUE]

ActivityNamesdata <- merge(MeanAndStdData, activity_labels,
                           by='activity_Id',
                           all.x=TRUE)

TidydataSet <- aggregate(. ~subject_Id + activity_Id, ActivityNamesdata, mean)
TidydataSet <- TidydataSet[order(TidydataSet$subject_Id, TidydataSet$activity_Id),]

write.table(TidydataSet, "Tidydata.txt", row.name=FALSE)



